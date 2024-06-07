# frozen_string_literal: true
require 'colorize'
h = { 1 => 'Uday', 2 => 'Mahesh', 3 => 'Chirag', 4 => 'Payal', 5 => 'Gagan', 6 => 'Deepak', 7 => 'OM', 8 => 'Janak', 9 => 'Adarsh',
      10 => 'Mayur', 11 => 'Shiwam', 12 => 'Gokul', 13 => 'Harshal', 14 => 'Aman', 15 => 'Kuldeep', 16 => 'Shubham' }

a = h.keys
team_red = []
team_blue = []
t = 1
h.each do |_key, _value|
  random = a.sample
  if t.even?
    team_red << h[random]
  else
    team_blue << h[random]
  end
  t += 1
  a.delete_at(a.find_index(random))
end
puts "Team RED(Shaan Sir)    \t:\t Team BLUE(Mohan Sir) "
puts '-------------------------------------'
(0...team_blue.length).each do |i|
  puts "#{team_red[i].red.on_white}    \t:\t #{team_blue[i].blue.on_white} ".bold
end
