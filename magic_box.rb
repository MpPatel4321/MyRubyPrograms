# frozen_string_literal: true

require 'byebug'

class MagicBox
  def initialize(number)
    @number = number
    @total_sum = total_sum
    @max_number = @total_sum / number
    @output = []
    @recursion_output = []
    @last_output = []
  end

  def run
    recursion_method(@number)
    arrange
    @last_output.each do |last_output|
      puts (last_output[0]).to_s
      puts (last_output[1]).to_s
      puts (last_output[2]).to_s
      puts ''
      puts ''
    end
  end

  def recursion_method(number)
    a_num = number
    number -= 1
    (1..(@number * @number)).each do |n|
      instance_variable_set("@n#{a_num}", n)
      recursion_method(number) if number.positive?
      arr = number_arr.map { |num| eval("@n#{num}") }.compact
      @output << arr if arr.sum == @total_sum / @number
    end
  end

  def number_arr
    (1..@number).to_a
  end

  def arrange
    recursion_method_for_output(@number)
    @recursion_output.each do |tem|
      @last_output << tem if tem[1][1] == 5
    end
  end

  def recursion_method_for_output(number)
    a_num = number
    number -= 1
    @output.each do |n|
      instance_variable_set("@output#{a_num}", n)
      recursion_method_for_output(number) if number.positive?
      is_true = []
      (0...eval_var_name(number_arr.last).size).each do |a|
        is_true << number_arr.map { |num| eval_var_name(num)[a] }.sum == @total_sum / @number
      end
      next unless is_true.uniq.size == 1

      next unless number_arr.map do |num|
                    eval_var_name(num)[num - 1]
                  end.sum == @total_sum / @number && number_arr.map do |num|
                                                       eval_var_name(num)[number_arr.last - num]
                                                     end.sum == @total_sum / @number

      out = number_arr.map { |num| eval_var_name(num) }.compact
      @recursion_output << out if out.flatten.uniq.size == @number * @number
    end
  end

  def eval_var_name(val)
    eval("@output#{val}")
  end

  def total_sum
    sum = 0
    (1..(@number * @number)).each do |j|
      sum += j
    end
    sum
  end
end

obj = MagicBox.new(5)
obj.run

# 2 7 6
# 9 5 1
# 4 3 8

# +------------------------+
# | 15 |  8 |  1 | 24 | 17 |
# +------------------------+
# | 16 | 14 |  7 |  5 | 23 |
# +------------------------+
# | 22 | 20 | 13 |  6 |  4 |
# +------------------------+
# |  3 | 21 | 19 | 12 | 10 |
# +------------------------+
# |  9 |  2 | 25 | 18 | 11 |
# +------------------------+
