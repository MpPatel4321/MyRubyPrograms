# frozen_string_literal: true

loop do
  random = rand(0...100)
  n1 = 6
  puts "you have #{n1} chance to guese the number."

  (0..n1).each do |i|
    puts 'Enter no.'
    n = gets.chomp.to_i

    if n > random
      if n / 2 >= random
        puts 'the random no too is smaller'
      else
        puts 'the random no is smaller'
      end
    elsif n < random
      if n + (n / 2) <= random
        puts 'the random no too is gretter'
      else
        puts 'the random no is gretter'
      end
    else
      puts 'You Won'
      break
    end
    next unless i == (n1 - 1)

    puts 'you lose'
    puts "the no is #{random}"
    break
  end
  puts 'play again'
  puts '1. yes'
  puts '2. no'
  input = gets.chomp.to_i
  case input
  when 1 then redo
  when 2
    puts 'bye-bye'
    break
  end
end
