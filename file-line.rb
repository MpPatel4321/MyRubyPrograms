# frozen_string_literal: true

class Abc
  def xyz
    puts 'hello'
    puts __FILE__
    puts __LINE__
  end
end

Abc.new.xyz
