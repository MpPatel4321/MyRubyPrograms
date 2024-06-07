# frozen_string_literal: true

require 'byebug'
class Opener
  OPENER = { '{' => '}', '(' => ')', '[' => ']' }.freeze
  def call(str, output = true)
    last_char = []
    str.each_char do |char|
      char = char.strip
      next if char.strip == ''

      if OPENER[char]
        last_char << char
      else
        last_char.last == OPENER.invert[char] ? last_char.pop : output = false
      end
    end
    puts output && last_char.size.zero?
  end
end

# ope = Opener.new("{ [ ( ) ] }")
# ope.call

# ope = Opener.new("{ [] ( ) }")
# ope.call

# ope = Opener.new("{ [ ( ] ) }")
# ope.call

# ope = Opener.new("{ [ ( ] }")
# ope.call

ope = Opener.new('(((((((({}[])())))))))((')
ope.call
