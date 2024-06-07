# frozen_string_literal: true

require 'byebug'
class Roman
  ROMAN_MAP = { 1 => 'I',
                4 => 'IV',
                5 => 'V',
                9 => 'IX',
                10 => 'X',
                40 => 'XL',
                50 => 'L',
                90 => 'XC',
                100 => 'C',
                400 => 'CD',
                500 => 'D',
                900 => 'CM',
                1000 => 'M' }.freeze

  def initialize(number)
    @number = number
  end

  def start
    output = @number.to_i.zero? && @number.to_i.to_s != @number ? roman_to_number : number_to_roman
    puts output
  end

  def number_to_roman(number = @number.to_i, output = '')
    ROMAN_MAP.reverse_each.each do |key, value|
      count, number = number.divmod(key)
      output += (value * count)
    end
    output
  end

  def roman_to_number(output = 0, skip1: false)
    roman_map = ROMAN_MAP.map(&:reverse).to_h
    (0...@number.size).each do |a|
      if skip1
        skip1 = false
        next
      end

      char = "#{@number[a]}#{@number[a + 1]}"
      if roman_map[char].nil?
        skip1 = false
        value = roman_map[@number[a]]
      else
        skip1 = true
        value = roman_map[char]
      end
      output += value
    end
    output
  end
end

Roman.new('9').start
# Roman.new('350').start
# Roman.new('8').start
# Roman.new('1800').start
# Roman.new('1150').start
# Roman.new('1942').start
# Roman.new('1976').start
# Roman.new('DI').start
# Roman.new('CCCL').start
# Roman.new('VIII').start
# Roman.new('MDCCC').start
# Roman.new('MCL').start
# Roman.new('MCMXLII').start
# Roman.new('MCMLXXVI').start
