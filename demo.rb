# frozen_string_literal: true

class Demo1
  def first
    @num_ar = []
    3.times do |i|
      puts 'Enter any number : '
      @num = gets.chomp.to_i
      @num_ar[i] = @num
    end
    puts @num_ar
  end

  def second
    @str_ar = []
    2.times do |i|
      puts 'Enter sub name : '
      @sub = gets.chomp
      @str_ar[i] = @sub
    end
  end

  def first1
    3.times do |_i|
      puts 'Enter any number : '
      loop do
        @num1 = gets.chomp.to_i
        break unless @num_ar.include?(@num1)

        puts 'this number is alredy exist. TRY AGAIN...'
        puts 'Enter another number : '
      end
      @num_ar.push(@num1)
    end
  end
end

class Demo < Demo1
  def demo
    @hsh = {}
    @hsh.merge!({ 'number' => @num_ar })
    @hsh.merge!({ 'String' => @str_ar })
    puts "hash is #{@hsh}"
  end
end
obj = Demo.new
obj.first
obj.first1
obj.second
obj.demo
