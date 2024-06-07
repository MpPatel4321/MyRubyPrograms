# frozen_string_literal: true

require 'byebug'
n = 10
sum = [1]
loop do
  s = sum.last + sum.last
  break if s > n

  sum << s
end
sum = sum.reverse
res = []
(0...sum.length).each do |s|
  res << (sum[s] <= n ? 1 : 0)
  n -= sum[s] if sum[s] <= n
end
puts "  #{res}   "
puts "  #{sum}   "
