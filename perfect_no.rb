# frozen_string_literal: true

class PerfectNo
  def run
    puts 'Enter No : '
    num = gets.chomp.to_i
    calculate(num)
  end

  def calculate(num)
    itarate_value = itarate(num).sum
    is_perfect = itarate_value == num || itarate(itarate_value).size == 1
    puts "#{num} is#{' not' unless is_perfect} Perfect No"
  end

  def itarate(num)
    arr = []
    (1...num).each do |n|
      arr << n if (num % n).zero?
    end
    arr
  end
end

PerfectNo.new.run
