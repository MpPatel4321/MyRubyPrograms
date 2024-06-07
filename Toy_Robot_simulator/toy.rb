# frozen_string_literal: true

# Toy  Simulator
class Toy
  DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze
  MAX = 5
  attr_accessor :current_direction, :x, :y, :max

  def initialize(x, y, f)
    @x = x
    @y = y
    @current_direction = f
  end

  def run
    puts 'Please use this Commands '
    puts '* PLACE,X,Y,F  (x and y is positions and f is direction)'
    input = gets.chomp.to_s
    if check_valid_command?(input)
      start
    else
      puts 'You Enter Wrong Command'
      run
    end
  end

  def check_valid_command?(input)
    input = input.split(',').map(&:strip)
    if 'PLACE'.include?(input[0]) && DIRECTIONS.include?(input[3])
      a = input[1].to_i
      c = input[2].to_i
      if a >= 0 && a <= MAX && c >= 0 && c <= MAX
        @current_direction = input[3]
        @x = a
        @y = c
        return true
      end
    end
    false
  end

  def start
    input = ''
    while input.downcase != 'exit'
      puts 'MOVE'
      puts 'LEFT'
      puts 'RIGHT'
      puts 'REPORT'
      puts '**************'
      print 'Enter '
      input = gets.chomp.to_s
      execute_command(input)
    end
  end

  def execute_command(input)
    case input
    when 'MOVE' then move
    when 'LEFT' then rotate_left
    when 'RIGHT' then rotate_right
    when 'REPORT' then report
    else puts 'Invalid command'
    end
  end

  def move
    case @current_direction
    when 'NORTH' then @x += 1 if @x != MAX
    when 'SOUTH' then @x -= 1 unless @x.zero?
    when 'EAST' then @y -= 1 unless @y.zero?
    when 'WEST' then @y += 1 if @y != MAX
    end
  end

  def rotate_left
    @current_direction = DIRECTIONS[DIRECTIONS.index(@current_direction) - 1]
  end

  def rotate_right
    index = DIRECTIONS.index(@current_direction) + 1
    @current_direction = DIRECTIONS[(index == 4 ? 0 : index)]
  end

  def report
    puts "Output : #{@x},#{@y},#{@current_direction}"
  end

  def position
    [@x, @y, @current_direction]
  end
end
toy = Toy.new(0, 0, 'EAST')
toy.run
