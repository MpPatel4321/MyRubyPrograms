# frozen_string_literal: true

require 'byebug'

class NumericMaze
  attr_reader :starting, :ending, :output

  def initialize(starting, ending)
    @starting = starting
    @ending = ending
    @output = [@starting]
    # @output << @starting
  end

  def run
    @starting < @ending ? accending : deccending
    puts @output.to_s
  end

  def accending
    loop do
      break if @ending == @output.last

      mode = (@ending % @output.last)
      if mode < 2 || @output.last <= @ending / 2
        @output << @output.last * 2
      elsif mode == 2 || @output.last / 2 < @ending
        @output << @output.last + 2
      elsif (mode > 2 && @output.last + 2 > @ending) || mode.zero?
        @output << @output.last / 2
      end
    end
  end

  def deccending
    @output = []
    @output << @ending
    loop do
      break if @starting == @output.last

      if multiply_check_for_deccending
        @output << @output.last * 2
      elsif (@output.last / 2 < @starting || @output.last >= @starting * 2) && @output.last / 2 != @starting
        @output << @output.last - 2
      elsif @output.last - 2 > @starting
        @output << @output.last / 2
      end
    end
    @output = @output.reverse
  end

  def multiply_check_for_deccending
    (@output.last <= @starting / 2 + 2 ||
    (@output.last <= @starting * 2 &&
    (@output.last > @starting &&
    @output.last < @starting + 2))) &&
      @output.last / 2 != @starting
  end
end

obj = NumericMaze.new(2, 6) #  => [2,4,8,16,18,9]
obj.run
obj = NumericMaze.new(6, 2)  # => [9,18,20,10,12,6,8,4,2]
obj.run
