# frozen_string_literal: true

require 'rubocop'
require 'colorize'

class NamePlate
  def call(word)
    word.chars.each_slice(15).map(&:join).each do |w|
      11.times do |i|
        (0...w.size).each do |k|
          11.times do |j|
            if send("#{w[k].strip.downcase}_word", i, j)
              print '*'.underline
            else
              print ' '
            end
          end
          print '  '
        end
        puts
      end
      2.times do |_i|
        puts
      end
    end
  end

  def a_word(i, j)
    (i / 2 + j == 5 || j - i / 2 == 5) && i.even? || (i == 5 && (3..7).any?(j))
  end

  def b_word(i, j)
    ([0, 10, 5].include?(i) && j < 8) || (j == 10 && [2, 3, 8,
                                                      7].any?(i)) || j.zero? || ([1, 4, 6, 9].any?(i) && j == 9)
  end

  def c_word(i, j)
    (i.zero? && j > 2) || (i == 10 && j > 2) || (j.zero? && i > 1 && i < 9) || ([1, 9].include?(i) && j == 1)
  end

  def d_word(i, j)
    ([0, 10].include?(i) && j < 8) || (j == 10 && i > 1 && i < 9) || ([1, 9].include?(i) && j == 9) || j.zero?
  end

  def e_word(i, j)
    i.zero? || i == 10 || j.zero? || i == 5
  end

  def f_word(i, j)
    i.zero? || j.zero? || i == 5
  end

  def g_word(i, j)
    (i.zero? && j > 2) || (i == 10 && j > 2) || (j.zero? && i > 1 && i < 9) || ([1,
                                                                                 9].include?(i) && j == 1) || (i > 5 && j == 10) || (i == 5 && j > 5)
  end

  def h_word(i, j)
    j.zero? || j == 10 || i == 5
  end

  def i_word(i, j)
    i.zero? || i == 10 || j == 5
  end

  def j_word(i, j)
    (i == 10 && (j < 8 && j > 2)) || ((j == 10 || (j.zero? && i > 4)) && i < 9) || ((i == 9) && j == 9) || ([1,
                                                                                                             9].include?(j) && i == 9)
  end

  def k_word(i, j)
    j.zero? || (i > 5 && i * 2 - j == 10) || (i < 5 && i * 2 + j == 10)
  end

  def l_word(i, j)
    j.zero? || i == 10
  end

  def m_word(i, j)
    j.zero? || j == 10 || (i == j && j <= 5) || (i + j == 10 && j > 5)
  end

  def n_word(i, j)
    j.zero? || j == 10 || i == j
  end

  def o_word(i, j)
    ([0,
      10].include?(i) && (j < 8 && j > 2)) || ([10,
                                                0].include?(j) && i > 1 && i < 9) || ([1,
                                                                                       9].include?(j) && [9,
                                                                                                          1].include?(i))
  end

  def p_word(i, j)
    ([0, 5].include?(i) && j < 10) || (i.positive? && i < 5 && j == 10) || j.zero?
  end

  def q_word(i, j)
    ([0,
      10].include?(i) && (j < 8 && j > 2)) || ([10,
                                                0].include?(j) && i > 1 && i < 9) || ([1,
                                                                                       9].include?(j) && [9,
                                                                                                          1].include?(i)) || (i == j && i > 6)
  end

  def r_word(i, j)
    ([0, 5].include?(i) && j < 10) || (i.positive? && i < 5 && j == 10) || j.zero? || ((i - j).zero? && i > 5)
  end

  def s_word(i, j)
    ([0, 5,
      10].include?(i) && (j < 10 && j.positive?)) || (i.positive? && i < 5 && j.zero?) || (i > 5 && i < 10 && j == 10)
  end

  def t_word(i, j)
    i.zero? || j == 5
  end

  def u_word(i, j)
    (i == 10 && (j < 8 && j > 2)) || ([10,
                                       0].include?(j) && i < 9) || ((i == 9) && j == 9) || ([1,
                                                                                             9].include?(j) && i == 9)
  end

  def v_word(i, j)
    (i / 2 == j || i + j == 10 + i / 2) && i.even?
  end

  def w_word(i, j)
    j.zero? || j == 10 || (i + j == 10 && j <= 5) || (i == j && j > 5)
  end

  def x_word(i, j)
    i == j || (i + j) == 10
  end

  def y_word(i, j)
    (i == j && i < 6) || (i + j == 10 && i < 6) || (j == 5 && i > 5)
  end

  def z_word(i, j)
    i.zero? || i == 10 || i + j == 10
  end

  def _word(_i, _j)
    false
  end
end

# NamePlate.new.call('a b c d e f g h')
# puts
# NamePlate.new.call('i j k l m n o p')
# puts
# NamePlate.new.call('q r s t u v w x')
# puts
# NamePlate.new.call('y z')
# puts
# puts
# NamePlate.new.call('mppatelmppatelm')
# puts
# puts
# puts
puts 'Enter Your name'
name = gets.chomp.to_s
NamePlate.new.call(name)
# NamePlate.new.call('mahesh')
puts
