# frozen_string_literal: true

class Town
  def judge(_n, input)
    trusty = input.map(&:first)
    judge = input.map(&:last)
    judge -= trusty
    count = judge.each_with_object(Hash.new(0)) { |judge, counts| counts[judge] += 1 }
    main_judge = []
    count.each { |k, v| main_judge.push(k) if v == count.values.max }
    case main_judge.length
    when 1
      puts main_judge
    when 0
      puts 0
    else
      puts(-1)
    end
  end
end

t = Town.new
t.judge(2, [[1, 2]])            # 2
t.judge(3, [[1, 3], [2, 3]])    # 3
t.judge(3, [[1, 3], [2, 3], [3, 1]]) # 0
t.judge(3, [[1, 2], [2, 3]]) # 3
t.judge(4, [[1, 3], [1, 4], [2, 3], [2, 4]])    #-1
