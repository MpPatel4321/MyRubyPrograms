# frozen_string_literal: true

require 'byebug'
class Calculator
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def add
    byebug
    puts (@a + @b).to_s
  end

  def subs
    puts @a - @b
  end

  def multi
    puts @a * @b
  end

  def div
    puts @a / @b
  end
end

calculator = Calculator.new(10, 5)
calculator.add
calculator.subs
calculator.multi
calculator.div
