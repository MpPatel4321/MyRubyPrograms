# frozen_string_literal: true

require 'byebug'
class MakingChange
  attr_accessor :amount, :output, :coins

  COINS = [2000, 500, 200, 100, 50, 20, 10, 5, 2, 1].freeze

  def initialize(amount, coins = [])
    @amount = amount
    @coins = coins.size.zero? ? COINS : coins.sort.reverse
    @output = []
    @remaining_amount = ''
  end

  def run
    calculate(@amount)
    puts @output.compact.to_s
    puts @remaining_amount.to_s unless @remaining_amount.nil?
  end

  def calculate(amount)
    loop do
      @output << @coins.select { |coin| coin <= amount }.first
      raise StandardError if @output.last.nil?

      amount -= @output.last
      break if amount.zero?
    end
  rescue StandardError
    @remaining_amount = "You have not a coin of #{amount}"
  end
end

change = MakingChange.new(14, [10, 5])
change.run
