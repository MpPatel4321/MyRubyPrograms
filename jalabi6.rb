# frozen_string_literal: true

# require 'byebug'
require 'benchmark'
def jalebi(n)
  n1 = 1 + ((n - 4) * 3)
  n2 = n > 5 ? ((n - 5) * 2) + n : n
  t = 1
  k = n - 2
  puts Benchmark.measure {
         (1..n).each do |i1|
           (1..n).each do |j|
             if j == n
               print "\t#{n + i1 - 1}"
             elsif j == n - 1 && i1 > 1 && i1 < n
               print "\t#{(4 * n) + (n - 5) + i1 - 3}"
             else
               print "\t#{t}"
             end
             r1 = n - i1
             if i1 == n
               t -= 1
             elsif i1 == 3 && j == 1 # (n%2 == 0 && i1 == n/2) || (n%2 != 0 && i1 == (n/2)+1) && j == 1
               t += n + n1
             elsif i1 == (n - 1) && j.positive?
               if j == 1
                 t += i1 + n2
               else
                 t -= 1
               end
             else
               t += 1
             end
           end
           t = ((n - 1) * 2) + n + k
           k -= 1
           puts ''
         end
       }
end

# jalebi(2)
# puts ""
# jalebi(3)
# puts ""
# jalebi(4)
# puts ""
# jalebi(5)
# puts ""
jalebi(6)

#  01,02,03,04,05,
#  16,17,18,19,06,
#  15,24,25,20,07,
#  14,23,22,21,08,
#  13,12,11,10,09

#  01,02,03,04,05,06
#  20,21,22,23,24,07
#  19,32,33,34,25,08
#  18,31,36,35,26,09
#  17,30,29,28,27,10
#  16,15,14,13,12,11

# i = 1

# a.each do |n|
#   print  "  #{n}"
#   puts "" if (i%5 == 0)
#   i += 1
# end
