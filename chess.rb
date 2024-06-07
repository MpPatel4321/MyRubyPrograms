# frozen_string_literal: true

require 'colorize'
require 'byebug'

class Chess
  BOARD = { 1 => 'BEL', 2 => 'BHL', 3 => 'BCL', 4 => 'BK', 5 => 'BQ', 6 => 'BCR', 7 => 'BHR', 8 => 'BER',
            9 => 'BG1', 10 => 'BG2', 11 => 'BG3', 12 => 'BG4', 13 => 'BG5', 14 => 'BG6', 15 => 'BG7', 16 => 'BG8',
            49 => 'WG1', 50 => 'WG2', 51 => 'WG3', 52 => 'WG4', 53 => 'WG5', 54 => 'WG6', 55 => 'WG7', 56 => 'WG8',
            57 => 'WEL', 58 => 'WHL', 59 => 'WCL', 60 => 'WQ', 61 => 'WK', 62 => 'WCR', 63 => 'WHR', 64 => 'WER' }.freeze

  IDENTITY = { 'G' => :gaurd, 'E' => :elephant, 'H' => :hourse, 'C' => :camel, 'Q' => :queen, 'K' => :king }.freeze
  EMOJI = { 'G' => '♟', 'E' => '♜', 'H' => '♞', 'C' => '♝', 'Q' => '♛', 'K' => '♚' }.freeze

  def initialize
    @board = set_board(false)
    @which = ''
    @where = ''
    @check = ''
    @mate = false
    @king_moves = []
    @turn = 'B'
    @posible_moves = []
    @double_move = { 'W' => 2, 'B' => 2 }
    @selected = false
  end

  def set_board(is_dummy, data = BOARD)
    board = {}
    (1..64).to_a.each do |a|
      value = is_dummy ? a.to_s : ''
      board[a] = data[a].nil? ? value : data[a]
    end
    board
  end

  def print_output_with_dummy
    puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts 'DUMMY Board'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    print_output(set_board(true, {}))
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts 'YOUR Board'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    print_output(@board)
  end

  def header_line
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts 'Enter no. from DUMMY board to Select Your Player and RESTART for restart the game and 0 for select again'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts "#{@turn == 'W' ? 'YELLOW\'s' : 'BLUE\'s'} Turn".bold.white.send(@turn == 'W' ? :on_light_yellow : :on_blue)
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    game_run
  end

  def game_run
    game_command = gets.chomp
    Chess.new.run if game_command.upcase == 'RESTART'
    exit if game_command.upcase == 'EXIT'
    game_command = game_command.to_i
    reset_selection if game_command.zero?
    if game_command < 1 || game_command > 64
      puts 'You entered Wrong Command'
      game_run
    end
    run_game_command(game_command)
    header_line
  end

  def reset_selection
    reset_all_values
    repeat
  end

  def reset_all_values
    @selected = !@selected
    @posible_moves = []
    @which = ''
  end

  def run_game_command(command)
    if validate_command(command)
      if @selected
        validation_msg("Box #{command} is Invalid....") unless @posible_moves.include?(command)
        @where = command
      else
        @which = command
      end
    end
    @selected ? reset_board : set_posible_moves
    print_output_with_dummy
  end

  def reset_board
    @board[@where] = @board[@which]
    @board[@which] = ''
    @selected = !@selected
    @double_move[@turn] -= 1 if @posible_moves[1] == @where && @board[@where].split('')[1] == 'G'
    @turn = @turn == 'B' ? 'W' : 'B'
    check_and_mate(@turn)
    @posible_moves = []
    repeat
  end

  def validate_command(command)
    validation_msg("Box #{command} is not Your Player....") if check_turn(command) && !@selected
    validation_msg("Box #{command} is Blank....") if @board[command] == '' && !@selected
    true
  end

  def validation_msg(message, is_game_run = false)
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts message
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    reset_all_values if is_game_run
    game_run
  end

  def check_turn(command = @which)
    @board[command].split('').first != @turn
  end

  def set_posible_moves
    str = @board[@which].split('')[1]
    @king_moves = check_king_moves if IDENTITY[str] == :king
    @temp = @which
    @temp_turn = @turn
    @posible_moves = send(IDENTITY[str])
    @selected = !@selected
    return unless @posible_moves.none?

    validation_msg("Box #{@which}(#{@board[@which].bold}) has no move available....", true)
    reset_all_values
  end

  def gaurd
    move = eval_string(@temp, 8, check_symbol).abs
    move1 = eval_string(move, 8, check_symbol).abs if (@double_move[@temp_turn]).positive?
    kill_move = check_killing_move(eval_string(@temp, 7, check_symbol).abs)
    kill_move1 = check_killing_move(eval_string(@temp, 9, check_symbol).abs)
    [validat_move_for_gaurd(move), validat_move_for_gaurd(move1), kill_move, kill_move1].compact
  end

  def elephant
    [elephant_posible_moves(8), elephant_posible_moves(1)].flatten.compact.uniq
  end

  def hourse
    [hourse_posible_moves(6), hourse_posible_moves(10), hourse_posible_moves(15),
     hourse_posible_moves(17)].flatten.compact.uniq
  end

  def camel
    [camel_posible_moves(7), camel_posible_moves(9)].flatten.compact.uniq
  end

  def queen
    [elephant, camel].flatten.compact.uniq
  end

  def king
    all_moves = [king_posible_moves(1), king_posible_moves(7), king_posible_moves(8),
                 king_posible_moves(9)].flatten.compact.uniq
    all_moves - @king_moves
  end

  def eval_string(val1, val2, symbol)
    eval("#{val1} #{symbol} #{val2}", binding, __FILE__, __LINE__)
  end

  def check_symbol
    @temp_turn == 'W' ? '-' : '+'
  end

  def validat_move_for_gaurd(move)
    move if @board[move] == ''
  end

  def elephant_posible_moves(number)
    moves = []
    ['+', '-'].each do |symbol|
      moves1 = []
      loop do
        value = fetch_elephant_camel_value(moves1, number, symbol)
        break if common_validation(value)
        break if validat_move_for_elephent(value, symbol, number)

        moves1 << value
        moves1 << check_killing_move(value)
        break if @board[value] != ''
      end
      moves << moves1
    end
    moves.flatten.compact
  end

  def hourse_posible_moves(number)
    moves = []
    ['+', '-'].each do |symbol|
      value = eval_string(@temp, number, symbol)
      next if common_validation(value)
      next if validat_move_for_hours(value, symbol, number)

      if ![17,
           10].include?(number) && ((symbol == '+' && (value % 8).zero?) || (symbol == '-' && ((value - 1) % 8).zero?))
        next
      end

      moves << value
      moves << check_killing_move(value)
    end
    moves.flatten.compact
  end

  def camel_posible_moves(number)
    moves = []
    ['+', '-'].each do |symbol|
      moves1 = []
      loop do
        value = fetch_elephant_camel_value(moves1, number, symbol)

        break if common_validation(value)
        break if validat_move_for_camel(value, symbol, number)

        moves1 << value
        moves1 << check_killing_move(value)
        break if (symbol == '-' && (value % 8) == 1) || (symbol == '+' && (value % 8).zero?)
        break if @board[value] != '' || [0, 1].include?(value % 8)
      end
      moves << moves1
    end
    moves.flatten.compact
  end

  def king_posible_moves(number)
    moves = []
    ['+', '-'].each do |symbol|
      value = eval_string(@temp, number, symbol)

      next if common_validation(value)

      moves << value
      moves << check_killing_move(value)
    end
    moves.flatten.compact
  end

  def fetch_elephant_camel_value(moves1, number, symbol)
    moves1 = moves1.flatten.compact.uniq
    value1 = moves1.empty? ? @temp : moves1.last
    eval_string(value1, number, symbol)
  end

  def common_validation(value)
    (value < 1 || value > 64) || @board[value]&.split('')&.first == @temp_turn
  end

  def validat_move_for_elephent(value, symbol, number)
    return false if [8].include?(number)
    return true if (symbol == '+' && (value % 8) == 1) || (symbol == '-' && (value % 8).zero?)

    false
  end

  def validat_move_for_hours(_value, symbol, number)
    return true if exicute_validation_for_hours(symbol, number)

    false
  end

  def validat_move_for_camel(value, symbol, number)
    if (symbol == '+' && number == 7) || (symbol == '-' && number == 9)
      return true if (value % 8).zero?
    elsif (symbol == '+' && number == 9) || (symbol == '-' && number == 7)
      return true if (value % 8) == 1
    end
    false
  end

  def exicute_validation_for_hours(symbol, number)
    validate_hourse([1, 2], symbol, '+', number, 6) || validate_hourse([7, 0], symbol, '-', number, 6) ||
      validate_hourse([0], symbol, '+', number, 17) || validate_hourse([1], symbol, '-', number, 17) ||
      validate_hourse([7, 0], symbol, '+', number, 10) || validate_hourse([1, 2], symbol, '-', number, 10)
  end

  def validate_hourse(values, symbol1, symbol2, number1, number2)
    values.include?(@temp % 8) && symbol1 == symbol2 && number1 == number2
  end

  def check_killing_move(value)
    if (@board[value] != '' && @board[@temp].split('').first == @temp_turn && @board[value]&.split('')&.first != @temp_turn) || @turn != @temp_turn
      value
    end
  end

  def check_king_moves
    @temp_turn = @turn == 'B' ? 'W' : 'B'
    check_king_killing(@temp_turn).values.compact.flatten.uniq
  end

  def all_positions(turn)
    turn = turn == 'B' ? 'W' : 'B'
    @board.select { |_a, v| v.split('').first == turn }.keys
  end

  def check_king_killing(turn)
    posible_moves = {}
    all_positions(turn).each do |position|
      str = @board[position].split('')[1]
      @temp = position
      posible_moves[position] = send(IDENTITY[str])
    end
    posible_moves
  end

  def check_and_mate(turn)
    @temp_turn = turn == 'B' ? 'W' : 'B'
    king_position = @board.invert["#{turn}K"]
    moves = check_king_killing(turn).select { |_k, v| v.include?(king_position) }.values.compact.flatten
    @check = "#{@temp_turn == 'B' ? 'YELLOW' : 'BLUE'} has checked" if moves.size.positive?
    @temp = king_position
    @king_moves = check_king_moves
    @mate = true if (king - moves).empty? && @check != ''
    @king_moves = []
  end

  def print_output(board)
    print 'BLUE SIDE'.rjust(29).bold.white.on_blue
    puts ''.ljust(20).bold.white.on_blue
    puts '-------------------------------------------------'.red.on_red
    itarate_board(board)
    print 'YELLOW SIDE'.rjust(29).bold.white.on_light_yellow
    puts ''.ljust(20).bold.white.on_light_yellow
    puts
  end

  def itarate_board(board)
    board.each do |key, value|
      print get_text_color(key, value)
      if (key % 8).zero?
        puts '|'.red.on_red
        puts '-------------------------------------------------'.red.on_red
      end
    end
  end

  def get_text_color(key, value)
    str = '|'.red.on_red
    str + set_move_color(value, white?(key), key)
  end

  def set_move_color(value, is_white, key)
    value1 = value.to_i.zero? && value != '' ? EMOJI[value.split('')[1]] : value
    if @posible_moves.include?(key) || @which == key # || (@where == key && @selected)
      set_colors(value, value1, :on_green)
    elsif is_white
      set_colors(value, value1, :on_black)
    else
      set_colors(value, value1, :on_white)
    end
  end

  def set_colors(value, value1, color)
    if value.split('')[0] == 'B' || @board[value]&.split('') & [0] == 'B'
      " #{value1.rjust(2)}  ".bold.blue.send(color)
    else
      " #{value1.rjust(2)}  ".bold.light_yellow.send(color)
    end
  end

  def white?(key)
    is_even = (key % 8).zero? ? (key / 8).odd? : (key / 8).even?
    is_even ? key.even? : key.odd?
  end

  def run
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts '>>> Welcome To the Game Board <<<'
    puts '>>> You represent the X player <<<'
    puts 'START. for Start Game.'
    puts 'RESTART. for Restart Game.'
    puts 'EXIT for exit from the game.'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    execute_command(gets.chomp)
  end

  def execute_command(command)
    case command.upcase
    when 'START' then start
    when 'RESTART' then Chess.new.run
    when 'EXIT' then exit
    else
      puts 'Plese enter valid Command'
      run
    end
  end

  def start
    print_output_with_dummy
    repeat
  end

  def repeat
    result = check_result
    print_output_with_dummy
    puts "#{@check} and Mate".blink.red.on_white if @check != ''
    if result.nil?
      @check = ''
      header_line
      game_run
    end
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    print "`#{result}`"
    puts ' 🎇🎇🎉🎉🎉🎉🎇🎇'.blink
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    puts 'Thanks For Playing'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    Chess.new.run
  end

  def check_result
    return 'Blue Won' if @board.invert['WK'].to_i.zero? || (@mate && @turn == 'W')
    return 'Yellow Won' if @board.invert['BK'].to_i.zero? || (@mate && @turn == 'B')
  end
end

Chess.new.run
