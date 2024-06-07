# frozen_string_literal: true

# require 'byebug'
n = 5
n1 = 1 + ((n - 4) * 3)
t = 1
k = n - 2
s1 = n + 1
s2 = 1
ss = true
(1..n).each do |i1|
  (1..n).each do |j|
    if j == n
      print "\t#{n + i1 - 1}"
    elsif j == s1 && i1 == s2 && n > 3 && ss
      print "\t#{(4 * n) + (n - 5)}"
      ss = false
    else
      print "\t#{t}"
    end
    if i1 == n
      t -= 1
    elsif i1 == 3 && j == 1
      t += n + n1
    elsif i1 == (n - 1) && j.positive?
      if j == 1
        t += i1 + n
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
  s1 -= 1
  s2 += 1
end

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
