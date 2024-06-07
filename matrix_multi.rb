# frozen_string_literal: true

class MatrixMulti
  def initialize(arr1, arr2)
    @array2 = arr1
    @array1 = arr2
    @output = []
  end

  def start
    3.times do |i|
      arr = []
      3.times do |_j|
        sum = 0
        3.times do |k|
          sum += (@array1[k][k] * @array2[i][k])
        end
        arr << sum
      end
      @output << arr
    end
    output
  end

  def output
    puts '***************************'
    puts 'Metrix > 1'
    puts '***************************'
    puts (@array2[0]).to_s
    puts (@array2[1]).to_s
    puts (@array2[2]).to_s
    puts '***************************'
    puts 'Metrix > 2'
    puts '***************************'
    puts (@array1[0]).to_s
    puts (@array1[1]).to_s
    puts (@array1[2]).to_s
    puts '***************************'
    puts 'Metrix > 1 * Metrix > 2 '
    puts '***************************'
    puts (@output[0]).to_s
    puts (@output[1]).to_s
    puts (@output[2]).to_s
  end
end

MatrixMulti.new([[1, 1, 1], [2, 2, 2], [3, 3, 3]], [[1, 1, 1], [2, 2, 2], [3, 3, 3]]).start

# 1 1 1
# 2 2 2
# 3 3 3
