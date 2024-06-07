# frozen_string_literal: true

# Toy Robot Simulator
class Robot
  attr_accessor :curent_direction, :x, :y

  MAX = 5
  DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze
  def initialize
    @x = 0
    @y = 0
    @current_direction = ''
  end

  def run
    puts 'Please use this Commands '
    puts '* PLACE,X,Y,F  (x and y is positions and f is direction)'
    puts '* MOVE'
    puts '* LEFT'
    puts '* RIGHT'
    puts '* REPORT'
    validator(gets.chomp.to_s.split(',').map(&:strip))
  end

  def validator(input)
    if 'PLACE'.include?(input[0]) && DIRECTIONS.include?(input[3])
      @current_direction = input[3]
      @x = input[1].to_i
      @y = input[2].to_i
      start
    else
      puts 'You Enter Wrong Command'
      run
    end
  end

  def start
    input = gets.chomp.to_s
    case input
    when 'MOVE' then move
    when 'LEFT' then check_direction(1)
    when 'RIGHT' then check_direction(-1)
    when 'REPORT' then report
    else
      puts 'You Enter Wrong Command'
      start
    end
  end

  def move
    case @current_direction
    when 'NORTH' then ns_position(1) unless @x == MAX
    when 'SOUTH' then ns_position(-1) unless @x.zero?
    when 'EAST' then ew_position(-1) unless @y.zero?
    when 'WEST' then ew_position(1) unless @y == MAX
    end
    report
  end

  def ns_position(number)
    @x += number
    report
  end

  def ew_position(number)
    @y += number
    report
  end

  def check_direction(number)
    temp = 0
    DIRECTIONS.each do |d|
      if d.include?(@current_direction)
        temp += number
        reset_direction(temp)
      end
      temp += 1
    end
  end

  def reset_direction(number)
    @current_direction = if number.negative?
                           DIRECTIONS[3]
                         elsif number > 3
                           DIRECTIONS[0]
                         else
                           DIRECTIONS[number]
                         end
    report
  end

  def report
    puts "Output : #{@x},#{@y},#{@current_direction}"
    start
  end
end

r = Robot.new
r.run
