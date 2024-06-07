# frozen_string_literal: true

require 'byebug'
a = [2, 3, 4, 5, 6, 7, 8, 9]
notprime = 0
prime = 0
a.each do |b|
  (2...b).each do |d|
    if (b % d).zero?
      if b == d
        prime += 1
      else
        notprime += 1
      end
    else
      prime += 1
    end
    break
  end
end
puts notprime
puts prime
