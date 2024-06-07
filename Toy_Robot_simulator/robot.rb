# frozen_string_literal: true

class Robot
  attr_reader :robot, :start, :curent_direction, :directions

  def initialize
    @robot = []
    @start = 0
    @curent_direction = ''
    @directions = %w[north east south west]
  end

  def run
    puts '1. for PLACE Robot to the start position (0,0)'
    puts '2. for MOVE'
    puts '3. for LEFT'
    puts '4. for RIGHT'
    puts '5. for REPORT'
    puts '6. for EXIT'
    puts ''
    input = gets.chomp.to_i
    puts ''
    case input
    when 1 then place
    when 2 then move
    when 3
    when 4
    when 5
    when 6 then exit
    else
      puts 'Please enter correct no.'
      puts ''
      run
    end
  end

  def place
    @robot = [0, 0]
    @curent_direction = 'north'
    show
  end

  def move
    if @robot.nil?
      puts 'First set the PLACE of robot'
      puts ''
      run
    else
      case @curent_direction
      when 'north'
        @robot[1] += 1
        if @robot[1] > 4
          puts 'You are in last state'
          @robot[1] -= 1
        elsif (@robot[1]).negative?
          puts 'You are in last state'
          @robot[1] += 1
        end
      when 'south'
        @robot[1] -= 1
        if @robot[1] > 4
          puts 'You are in last state'
          @robot[1] -= 1
        elsif (@robot[1]).negative?
          puts 'You are in last state'
          @robot[1] += 1
        end
      when 'east'
        @robot[0] += 1
        if @robot[0] > 4
          puts 'You are in last state'
          @robot[0] -= 1
        elsif (@robot[1]).negative?
          puts 'You are in last state'
          @robot[1] += 1
        end
      when 'west'
        @robot[0] -= 1
        if @robot[0] > 4
          puts 'You are in last state'
          @robot[0] -= 1
        elsif (@robot[1]).negative?
          puts 'You are in last state'
          @robot[1] += 1
        end
      end
    end
    show
  end

  def chenge_direction; end

  def show
    puts ' ---------------'
    5.times do |i|
      print '|'
      position = 0
      5.times do |j|
        position = 1 unless @robot.nil?
        case position
        when 1
          if (i == @robot[0]) && (j == @robot[1])
            print ' @ '
          else
            print '   '
          end
        else print '   '
        end
      end
      print '|'
      puts ''
    end
    puts ' ---------------'
    puts ''
    run
  end
end

r = Robot.new
r.show
