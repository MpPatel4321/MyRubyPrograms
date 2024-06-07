# frozen_string_literal: true

def possible_balance(data, balance)
  d = data.split('')
  r = 0
  loop do
    num = 0
    (0...d.length).each do |i|
      if d[i] == '+'
        num += 1
      else
        num -= 1
      end
    end
    if balance.negative?
      if num < balance
        d.pop
        r += 1
        redo
      end
    elsif num < balance
      if d.last == '-'
        d.pop
        r += 1
        redo
      else
        r = -1
      end
    end
    break
  end
  puts r
end

possible_balance('++-', 2) # should return 1
possible_balance('+++-++-++--+-++++-+--++-++-+-++++-+++--', 12) # 1
possible_balance('+++-++-++--+-++++-+--++-++-+-++++-+++--', 13) # 2
possible_balance('+++-++-++--+-++++-+--++-++-+-++++-+++--', 14) # -1
possible_balance('+++---', 3) # // 3
possible_balance('+++-+---', 3) # // 3
possible_balance('----+-', -2) # 4
