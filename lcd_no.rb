# frozen_string_literal: true

require 'rubocop'
class LcdNo
  NO_DATA = {
    '0' => [1, 3, 0, 3, 1],
    '1' => [0, 1, 0, 1, 0],
    '2' => [1, 2, 1, 1, 1],
    '3' => [1, 2, 1, 2, 1],
    '4' => [0, 3, 1, 2, 0],
    '5' => [1, 1, 1, 2, 1],
    '6' => [1, 1, 1, 3, 1],
    '7' => [1, 2, 0, 2, 0],
    '8' => [1, 3, 1, 3, 1],
    '9' => [1, 3, 1, 2, 1]
  }.freeze

  def initialize(size, number)
    @size = size
    @number = number
  end

  def start
    5.times do |index|
      @size.times do |_i|
        @number.each_char { |digit| print " #{output(NO_DATA[digit][index], index)} " }
        puts
        break if index.even?
      end
    end
  end

  def output(data, line)
    if line.odd?
      print_horizental(data)
    else
      " #{(data.zero? ? '' : ('-' * @size)).rjust(@size)} "
    end
  end

  def print_horizental(data)
    space = ''.rjust(@size)
    case data
    when 1 then "|#{space} "
    when 2 then " #{space}|"
    when 3 then "|#{space}|"
    end
  end
end
LcdNo.new(8, '0123456789').start
puts
# LcdNo.new(1, '1').start
# puts
# LcdNo.new(1, '2').start
# puts
# LcdNo.new(1, '3').start
# puts
# LcdNo.new(1, '4').start
# puts
# LcdNo.new(1, '5').start
# puts
# LcdNo.new(1, '6').start
# puts
# LcdNo.new(1, '7').start
# puts
# LcdNo.new(1, '8').start
# puts
# LcdNo.new(1, '9').start

#  -
# | |

# | |
#  -

#  [1,3,0,3,1]

#  |

#  |

#  [0,1,0,1,0]

#   -
#    |
#   -
#  |
#   -

#   [1,2,1,1,1]

#    -
#     |
#    -
#     |
#    -

#    [1,2,1,2,1]

#    | |
#     -
#      |

#     [0,3,1,2,0]

#     -
#    |
#     -
#      |
#     -

#     [1,1,1,2,1]

#     -
#    |
#     -
#    | |
#     -

#     [1,1,1,3,1]

#     -
#      |

#      |

#     [1,2,0,2,0]

#     -
#    | |
#     -
#    | |
#     -

#    [1,3,1,3,1]

#    -
#   | |
#    -
#     |
#    -

#    [1,3,1,2,1]
