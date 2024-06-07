# frozen_string_literal: true

require 'colorize'
# Sorted path
class Pawan
  def initialize(arr)
    @position = arr
    @path = { 'start' => arr }
  end

  def start
    loop do
      print_output

      break if @path.values.size == 9 || available_moves.values.size.zero?

      move = set_next_move
      @path[available_moves.key(move)] = move
      @position = move
    end
    @path
  end

  def set_next_move
    arr = next_move
    @path.values.include?(arr.first) ? arr[1] || arr[0] : arr[0]
  end

  def next_move
    available_moves.values.sort! { |a, b| [a[0], a[1]] <=> [b[0], b[1]] }
  end

  def available_moves
    direction_hash.compact
  end

  def direction_hash
    { 'N' => north, 'NW' => north_west, 'W' => west, 'SW' => south_west, 'S' => south, 'SE' => south_east, 'E' => east,
      'NE' => north_east }
  end

  def validate?(position)
    cordinate?(position[0]) && cordinate?(position[1])
  end

  def cordinate?(point)
    point >= 0 && point <= 9
  end

  def north
    evaluate(-3, 0, 'N')
  end

  def north_west
    evaluate(-2, -2, 'NW')
  end

  def west
    evaluate(0, -3, 'W')
  end

  def south_west
    evaluate(2, -2, 'SW')
  end

  def south
    evaluate(3, 0, 'S')
  end

  def south_east
    evaluate(2, 2, 'SE')
  end

  def east
    evaluate(0, 3, 'E')
  end

  def north_east
    evaluate(-2, 2, 'NE')
  end

  def evaluate(first, second, direction)
    cordinates = eval_cordinates(first, second)
    validate?(cordinates) && available?(direction) ? cordinates : nil
  end

  def available?(direction)
    @path[direction].nil?
  end

  def eval_cordinates(first, second)
    [@position[0] + first, @position[1] + second]
  end

  def print_output
    puts '+----+----+----+----+----+----+----+----+----+----+'
    10.times do |x|
      10.times do |y|
        print "|#{fetch_value([x, y]).bold}"
      end
      puts '|'
      puts '+----+----+----+----+----+----+----+----+----+----+'
    end
  end

  def fetch_value(arr)
    str = dynamic_data_hash[arr]
    case str.to_s
    when 'X' then str.rjust(4).green.on_red
    when '' then str.to_s.rjust(4)
    else
      str.rjust(4).on_green
    end
  end

  def dynamic_data_hash
    direction_hash.invert.merge({ @position => 'X' })
  end
end

puts Pawan.new([0, 0]).start
# puts Pawan.new([0, 1]).start
# puts Pawan.new([0, 2]).start
# puts Pawan.new([0, 3]).start
# puts Pawan.new([0, 4]).start
# puts Pawan.new([0, 5]).start
# puts Pawan.new([0, 6]).start
# puts Pawan.new([0, 7]).start
# puts Pawan.new([0, 8]).start
# puts Pawan.new([0, 9]).start
# puts
# puts Pawan.new([1, 0]).start
# puts Pawan.new([1, 1]).start
# puts Pawan.new([1, 2]).start
# puts Pawan.new([1, 3]).start
# puts Pawan.new([1, 4]).start
# puts Pawan.new([1, 5]).start
# puts Pawan.new([1, 6]).start
# puts Pawan.new([1, 7]).start
# puts Pawan.new([1, 8]).start
# puts Pawan.new([1, 9]).start
# puts
# puts Pawan.new([2, 0]).start
# puts Pawan.new([2, 1]).start
# puts Pawan.new([2, 2]).start
# puts Pawan.new([2, 3]).start
# puts Pawan.new([2, 4]).start
# puts Pawan.new([2, 5]).start
# puts Pawan.new([2, 6]).start
# puts Pawan.new([2, 7]).start
# puts Pawan.new([2, 8]).start
# puts Pawan.new([2, 9]).start
# puts
# puts Pawan.new([3, 0]).start
# puts Pawan.new([3, 1]).start
# puts Pawan.new([3, 2]).start
# puts Pawan.new([3, 3]).start
# puts Pawan.new([3, 4]).start
# puts Pawan.new([3, 5]).start
# puts Pawan.new([3, 6]).start
# puts Pawan.new([3, 7]).start
# puts Pawan.new([3, 8]).start
# puts Pawan.new([3, 9]).start
# puts
# puts Pawan.new([4, 0]).start
# puts Pawan.new([4, 1]).start
# puts Pawan.new([4, 2]).start
# puts Pawan.new([4, 3]).start
# puts Pawan.new([4, 4]).start
# puts Pawan.new([4, 5]).start
# puts Pawan.new([4, 6]).start
# puts Pawan.new([4, 7]).start
# puts Pawan.new([4, 8]).start
# puts Pawan.new([4, 9]).start
# puts
# puts Pawan.new([5, 0]).start
# puts Pawan.new([5, 1]).start
# puts Pawan.new([5, 2]).start
# puts Pawan.new([5, 3]).start
# puts Pawan.new([5, 4]).start
# puts Pawan.new([5, 5]).start
# puts Pawan.new([5, 6]).start
# puts Pawan.new([5, 7]).start
# puts Pawan.new([5, 8]).start
# puts Pawan.new([5, 9]).start
# puts
# puts Pawan.new([6, 0]).start
# puts Pawan.new([6, 1]).start
# puts Pawan.new([6, 2]).start
# puts Pawan.new([6, 3]).start
# puts Pawan.new([6, 4]).start
# puts Pawan.new([6, 5]).start
# puts Pawan.new([6, 6]).start
# puts Pawan.new([6, 7]).start
# puts Pawan.new([6, 8]).start
# puts Pawan.new([6, 9]).start
# puts
# puts Pawan.new([7, 0]).start
# puts Pawan.new([7, 1]).start
# puts Pawan.new([7, 2]).start
# puts Pawan.new([7, 3]).start
# puts Pawan.new([7, 4]).start
# puts Pawan.new([7, 5]).start
# puts Pawan.new([7, 6]).start
# puts Pawan.new([7, 7]).start
# puts Pawan.new([7, 8]).start
# puts Pawan.new([7, 9]).start
# puts
# puts Pawan.new([8, 0]).start
# puts Pawan.new([8, 1]).start
# puts Pawan.new([8, 2]).start
# puts Pawan.new([8, 3]).start
# puts Pawan.new([8, 4]).start
# puts Pawan.new([8, 5]).start
# puts Pawan.new([8, 6]).start
# puts Pawan.new([8, 7]).start
# puts Pawan.new([8, 8]).start
# puts Pawan.new([8, 9]).start
# puts
# puts Pawan.new([9, 0]).start
# puts Pawan.new([9, 1]).start
# puts Pawan.new([9, 2]).start
# puts Pawan.new([9, 3]).start
# puts Pawan.new([9, 4]).start
# puts Pawan.new([9, 5]).start
# puts Pawan.new([9, 6]).start
# puts Pawan.new([9, 7]).start
# puts Pawan.new([9, 8]).start
# puts Pawan.new([9, 9]).start
