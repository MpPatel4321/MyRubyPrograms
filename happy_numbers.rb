# frozen_string_literal: true

require 'rubocop'
class HappyNumber
  def initialize(input)
    @input = input
    @outputs = []
  end

  def run
    loop do
      temp = @outputs.empty? ? @input : @outputs.last
      temp1 = 0
      temp.split('').each do |t|
        temp1 += (t.to_i * t.to_i)
      end
      break if @outputs.include?(@input) || @outputs.include?(temp1.to_s) || (temp1 == '1') || @input.to_i.zero?

      @outputs << temp1.to_s
    end
    result = (@outputs.last == '1' ? 'Happy Number' : 'UnHappy Number')
    puts "#{@input} is #{result}"
    puts "#{@input} : #{@outputs}"
  end
end

HappyNumber.new('12').run
