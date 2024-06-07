# frozen_string_literal: true

class Spiral
  def initialize(size)
    @size = size
    @center = size / 2
  end

  def run
    width = maximum_value.to_s.length + 3
    (0...@size).each do |row|
      (0...@size).each do |col|
        value = value_for_cordinates(row, col)
        print value.to_s.rjust(width)
      end
      puts
    end
  end

  def maximum_value
    @size * @size - 1
  end

  def value_for_cordinates(row, col)
    x, y = cordinates = cordinate_for(row, col)
    level = [x.abs, y.abs].max
    range = range_of_value(level)
    if x < level && y > -level
      range[0] + total_steps(first_cordinate(level), cordinates)
    else
      range[1] - total_steps(last_cordinate(level), cordinates)
    end
  end

  def first_cordinate(level)
    [-level, 1 - level]
  end

  def last_cordinate(level)
    [-level, -level]
  end

  def total_steps(nearest_cordinate, cordinates)
    (nearest_cordinate[0] - cordinates[0]).abs + (nearest_cordinate[1] - cordinates[1]).abs
  end

  def cordinate_for(row, col)
    [col - @center, @center - row]
  end

  def range_of_value(min_value)
    max_value = fetch_max_value(min_value)
    min_value = ((min_value * 2) - 1)**2
    [min_value, max_value]
  end

  def fetch_max_value(min_value)
    max_value = ((min_value * 2) + 1)**2
    (max_value - 1)
  end
end

Spiral.new(10).run
