# frozen_string_literal: true

require 'ruby2d'

Line.new(
  x1: 0, y1: 0,
  x2: 640, y2: 0,
  width: 5,
  color: 'red'
)
Line.new(
  x1: 0, y1: 0,
  x2: 0, y2: 480,
  # width: 5,
  color: 'red'
)
Line.new(
  x1: 640, y1: 0,
  x2: 640, y2: 480,
  # width: 5,
  color: 'red'
)
Line.new(
  x1: 0, y1: 480,
  x2: 640, y2: 480,
  # width: 5,
  color: 'red'
)

@square = Square.new(x: 2, y: 2, size: 15, color: 'blue')
# Define the initial speed (and direction).
@x_speed = 0
@y_speed = 0
@score = 0
set title: "Your Score : #{@score}"
@speed = 1
array = [5, 10, 15, 20, 25, 30, 35, 40]
# Define what happens when a specific key is pressed.
# Each keypress influences on the  movement along the x and y axis.
@square1 = Square.new(x: rand(0...615), y: rand(0...470), size: 10, color: 'white')
on :key_down do |event|
  case event.key
  when 'left'
    @x_speed = -@speed
    @y_speed = 0
  when 'right'
    @x_speed = @speed
    @y_speed = 0
  when 'up'
    @x_speed = 0
    @y_speed = -@speed
  when 'down'
    @x_speed = 0
    @y_speed = @speed
  end
end

update do
  @square.x += @x_speed
  @square.y += @y_speed
  if @square.x.negative?
    # @square.x = 615
    close
    puts "Your Score : #{@score}"
  elsif @square.x > 615
    # @square.x = 0
    close
    puts "Your Score : #{@score}"
  elsif @square.y.negative?
    # @square.y = 470
    close
    puts "Your Score : #{@score}"
  elsif @square.y > 470
    close
    puts "Your Score : #{@score}"
    # @square.y = 0
  end
  if (@square1.x..(@square1.x + 10)).include?(@square.x) && (@square1.y..(@square1.y + 10)).include?(@square.y)
    @score += 1
    @speed += 1 if array.include?(@score)
    @square1.x = rand(0..615)
    @square1.y = rand(0..470)
  end
end

show
