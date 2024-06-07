# frozen_string_literal: true

require 'byebug'
5.times do |r|
  (-4..4).each do |j|
    if r >= j.abs
      print ' * '
    else
      print '   '
    end
  end
  puts ''
end
puts ''
puts ''
5.times do |r|
  5.times do |j|
    if r >= j.abs
      print ' * '
    else
      print '   '
    end
  end
  puts ''
end
puts ''
puts ''
5.times do |r|
  (-4..0).each do |j|
    if r < j.abs
      print '   '
    else
      print ' * '
    end
  end
  puts ''
end
puts ''
puts ''
t = 0
(-4..4).each do |r|
  (-4..4).each do |j|
    if t >= j.abs
      print ' * '
    else
      print '   '
    end
  end
  if r.negative?
    t += 1
  elsif r >= 0
    t -= 1
  end
  puts ''
end
puts ''
puts ''
5.times do |r|
  (-4..0).each do |j|
    if r > j.abs
      print '   '
    else
      print ' * '
    end
  end
  puts ''
end
puts ''
puts ''
(-4..0).each do |r|
  (-4..4).each do |j|
    if r.abs < j.abs
      print '   '
    else
      print ' * '
    end
  end
  puts ''
end
puts ''
puts ''
5.times do |r|
  5.times do |j|
    if r > j.abs
      print '   '
    else
      print ' * '
    end
  end
  puts ''
end
puts ''
puts ''
t = 0
(-4..4).each do |r|
  5.times do |j|
    if t >= j.abs
      print ' * '
    else
      print '   '
    end
  end
  if r.negative?
    t += 1
  elsif r >= 0
    t -= 1
  end
  puts ''
end
puts ''
puts ''
t = 0
(-4..4).each do |r|
  (-4..0).each do |j|
    if t >= j.abs
      print ' * '
    else
      print '   '
    end
  end
  if r.negative?
    t += 1
  elsif r >= 0
    t -= 1
  end
  puts ''
end
puts ''
puts ''
(-4..0).each do |r|
  (-4..4).each do |j|
    if r.abs < j.abs
      print '   '
    else
      print ' * '
    end
  end
  puts ''
end
5.times do |r|
  (-4..4).each do |j|
    if r >= j.abs
      print ' * '
    else
      print '   '
    end
  end
  puts ''
end
puts ''
puts ''
5.times do |r|
  (-4..4).each do |j|
    if r == j.abs || r == 4
      print ' * '
    else
      print '   '
    end
  end
  puts ''
end
puts ''
puts ''
t = 0
(-4..4).each do |r|
  (-4..4).each do |j|
    if t == j.abs
      print ' * '
    else
      print '   '
    end
  end
  if r.negative?
    t += 1
  elsif r >= 0
    t -= 1
  end
  puts ''
end
puts ''
puts ''
t = 0
5.times do |r|
  5.times do |j|
    if r >= j.abs
      t += 1
      print t.to_s.ljust(4)
    else
      print '   '
    end
  end
  puts ''
end
puts ''
puts ''
5.times do |r|
  t = r.zero? ? 1 : r
  (-4..4).each do |j|
    if r >= j.abs
      if r == j.abs
        print " #{r} "
      else
        print '   '
      end
      j.negative? ? (t += 1) : (t -= 1)
    else
      print '   '
    end
  end
  puts ''
end
puts ''
puts ''
(1..7).each do |r|
  (1..7).each do |j|
    if r == j || r == 1 || r == 7 || j == 1 || j == 7 || j == 8 - r
      print ' * '
    else
      print '   '
    end
  end
  puts ''
end
puts ''
puts ''
t = 0
(-4..4).each do |r|
  (-4..4).each do |j|
    if r.abs == 4 || j.abs == 4 || t == j.abs || (r.zero? && j.abs == 3) || (r.abs == 3 && j.zero?)
      print ' * '
    else
      print '   '
    end
  end
  if r.negative?
    t += 1
  elsif r >= 0
    t -= 1
  end
  puts ''
end
puts ''
puts ''
(1..11).each do |r|
  (1..17).each do |j|
    a = (11 / 2) + 1
    b = (17 / 2) + 1
    if a == r || b == j || (r == 1 && j > b) || (r == 11 && j <= b) ||
       (r > a && j == 17) || (r <= a && j == 1) || (r == a / 2 && j == b / 2) ||
       (r == a / 2 && j == b / 2 + b + 1) || (r == a / 2 + a && j == b / 2) ||
       (r == a / 2 + a && j == b / 2 + b + 1)
      print '*'
    else
      print ' '
    end
  end
  puts ''
end
puts ''
puts ''
b = 1
(1..13).each do |r|
  b = 1 if r == 10
  (1..23).each do |j|
    if ([1, 10].include?(r) && j <= 20) ||
       (r == 4 && j > 3) ||
       (j == b || j == b + 19) ||
       ([1, 20].include?(j) && r < 10) ||
       ((r == 13 && j > 3) && j <= 23) ||
       (r > 9 && [4, 23].include?(j))
      print '*'
    else
      print ' '
    end
  end
  b += 1 if r < 4 || r > 8
  puts ''
end
puts ''
puts ''
tem = 1
(1..9).each do |i|
  (1..9).each do |j|
    if i == j || (i + j) == 10
      print tem
    else
      print ' '
    end
  end
  puts
  tem = i < 5 ? tem + 1 : tem - 1
end
puts ''
puts ''
