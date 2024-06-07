# frozen_string_literal: true

require 'rubocop'
module BestOutcome
  WINNER = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  def outcome
    posible_winnings_x = output_board('x').compact
    posible_winnings_o = output_board('o').compact
    o_position = iterate_winnings(posible_winnings_x, posible_winnings_o)
    @board_hash[o_position] = 'o'
    @board_hash.values.join
  end

  def iterate_winnings(posible_winnings_x, posible_winnings_o)
    positions_x, pw_x = get_positions_and_winning(posible_winnings_x, 'x')
    positions_o, pw_o = get_positions_and_winning(posible_winnings_o, 'o')
    if pw_o.nil?
      win_or_play(pw_x, positions_x, 'x')
    else
      win_or_play(pw_o, positions_o, 'o')
    end
  end

  def get_positions_and_winning(posible_winnings, player)
    positions = get_positions(@board_hash, player)
    pw = get_sorted_winning_positions(posible_winnings, positions).first
    [positions, pw]
  end

  def win_or_play(ppw, positions, player)
    return (ppw - positions).first unless ppw.nil?

    o_winning = output_board(player).compact

    o_winning.empty? ? win_or_play_second(positions) : o_winning.first
  end

  def win_or_play_second(positions)
    return check_corner(positions) if positions.size == 1 && [7, 3].include?(positions.first)
    return check_middel(positions) if positions.size == 2 &&
                                      ([8, 6].include?(positions.first) ||
                                      [8, 6].include?(positions.last))
    return 3 if positions.size == 2 && [5, 9].include?(positions.first) &&
                [5, 9].include?(positions.last)

    return_from_posible_moves
  end

  def return_from_posible_moves
    return 5 if posible_moves.keys.include?(5)

    posible_moves.keys.first
  end

  def check_corner(positions)
    positions.include?(3) ? 7 : 3
  end

  def check_middel(positions)
    arr = WINNER.select { |a| array_map(a, positions).include?(true) }
    arr = arr.select { |a| array_map(a, posible_moves.keys).count(true) == 2 }.flatten
    check_middel_second(arr, positions)
  end

  def check_middel_second(arr, positions)
    arr = arr.map { |a| { a => arr.count(a) } }.uniq.select { |a| a.values == [2] }
    arr.map(&:keys).flatten.reject { |a| positions.include?(a) }.first
  end

  def array_map(data_arr_one, data_arr_two)
    data_arr_one.map { |b| data_arr_two.include?(b) }
  end

  def get_sorted_winning_positions(posible_winnings, positions)
    posible_winnings.sort { |s| s.join.match(positions.join).to_s.size }.reverse
  end

  def output_board(player)
    result = []
    posible_moves.each do |key, _value|
      dumy_board_hash = {}
      dumy_board_hash = dumy_board_hash.merge(@board_hash)
      dumy_board_hash[key] = player
      result << set_result(dumy_board_hash, player)
    end
    result
  end

  def posible_moves
    @board_hash.select { |_key, value| value == ' ' }
  end

  def set_result(board_hash, player)
    player_x = get_positions(board_hash, player)
    player_x = arrange_player_x(player_x) unless player_x.size == 3
    get_winner(player_x)
  end

  def arrange_player_x(player_x)
    values = WINNER.map do |arr|
      value = arr.map { |a| player_x.join.match(a.to_s).to_s.to_i }
      value.include?(0) ? nil : value
    end.uniq.compact
    values.empty? ? player_x : values.flatten
  end

  def get_positions(board_hash, player)
    board_hash.select { |_key, value| value == player }.keys.sort
  end

  def get_winner(player_x)
    return unless WINNER.include?(player_x)

    player_x
  end
end

module EasyOutcome
  def easy_outcome
    move = posible_moves.keys[rand(posible_moves.size)]
    @board_hash[move] = 'o'
    @board_hash.values.join
  end
end

module GameBoard
  include BestOutcome
  include EasyOutcome

  def game_run
    game_command = gets.chomp
    TicTacToe.new.select_level if game_command.upcase == 'RESTART'
    game_command = game_command.to_i
    run_game_command(game_command) if game_command.positive? && game_command < 10
    puts 'You entered Wrong Command'
    header_line
  end

  def run_game_command(command)
    arr = @board.split('')
    @board_hash = arr.map.with_index(1) { |*x| x.reverse }.to_h
    validate_command(command)
    @board_hash[command] = 'x'
    @board = @board_hash.values.join
    repeat if board_size == 9
    @board = play_game
    start
  end

  def play_game
    @level == 'HARD' ? outcome : easy_outcome
  end

  def validate_command(command)
    return if @board_hash[command] == ' '

    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts "Box #{command} already selected..."
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    game_run
  end

  def print_output(arr)
    puts '+++++++++++++'
    arr.map.with_index(1) do |a, index|
      print "| #{a} "
      puts "|\n+++++++++++++" if (index % 3).zero?
    end
    puts
  end

  def check_result
    return if board_size < 4

    player_x = get_positions(@board_hash, 'x')
    player_x = arrange_player_x(player_x) unless player_x.size == 3
    player_o = get_positions(@board_hash, 'o')
    player_o = arrange_player_x(player_o) unless player_o.size == 3
    set_winner(player_x, player_o)
  end

  def set_winner(player_x, player_o)
    if WINNER.include?(player_x)
      'YOU WON'
    elsif WINNER.include?(player_o)
      'YOU LOST'
    elsif board_size == 9
      'DRAW'
    end
  end

  def board_size
    @board.gsub(' ', '').size
  end
end

class TicTacToe
  include BestOutcome
  include GameBoard

  def initialize
    @board = '         '
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
    when 'START' then select_level
    when 'RESTART' then TicTacToe.new.run
    when 'EXIT' then exit
    else
      puts 'Plese enter valid Command'
      run
    end
  end

  def select_level
    puts "\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts '>>> Select Level Of Your Game <<<'
    puts '1. EASY'
    puts '2. HARD'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    run_level_command(gets.chomp.to_i)
  end

  def run_level_command(command)
    if [1, 2].include?(command)
      @level = command == 1 ? 'EASY' : 'HARD'
      start
    else
      puts 'Plese enter valid Command'
      select_level
    end
  end

  def start
    print_output_with_dummy
    repeat
  end

  def repeat
    result = check_result
    header_line if result.nil?
    print_output_with_dummy
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts "`#{result}` Better Luck Next Time"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    puts 'Thanks For Playing'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    TicTacToe.new.run
  end

  def header_line
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts "Enter no. from DUMMY board to set your 'x' Value and RESTART for restart the game"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    game_run
  end

  def print_output_with_dummy
    puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts 'DUMMY Board'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    print_output((1..9).to_a)
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts 'YOUR Board'
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
    print_output(@board.split(''))
  end
end

TicTacToe.new.run
