# frozen_string_literal: true

a = [1, 2, 3, 4, 5, 6]
d = []
a.each do |b|
  tem = 1
  a.each do |c|
    tem *= c if b != c
  end
  d << tem
end
puts a.to_s
puts '--------------------'
puts d.to_s
