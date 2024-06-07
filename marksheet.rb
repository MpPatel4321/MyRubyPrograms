# frozen_string_literal: true

class Result
  $students = Hash[101 => 'xyz', 102 => 'abc', 103 => 'jkl']
  $marks = {
    101 => [80, 29, 78, 20, 79, 60],
    102 => [85, 81, 25, 40, 80, 65],
    103 => [85, 81, 29, 65, 80, 65]
  }
  $subject = {
    101 => ['Hindi', 'English', 'Maths', 'Sans.', 'SS', 'Sci.'],
    102 => ['Hindi', 'English', 'Maths', 'Sans.', 'SS', 'Sci.'],
    103 => ['Hindi', 'English', 'Maths', 'Sans.', 'SS', 'Sci.']
  }
  $max = {
    101 => [100, 100, 100, 100, 100, 100],
    102 => [100, 100, 100, 100, 100, 100],
    103 => [100, 100, 100, 100, 100, 100]
  }
  $student_subject = []
  $max_no = []
end

class Marksheet < Result
  def show_marksheet
    total = 0
    print "Enter Roll no. \t:  "
    roll_no = gets.to_i
    puts ''
    if !$students.include?(roll_no)
      puts 'Result Not Found'
      puts ''
    else
      puts "Roll no.   :\t#{roll_no} \nName\t:\t#{$students[roll_no]}\n\n"
      student_marks = $marks[roll_no]
      maximum_no = $max[roll_no]
      students_subject = $subject[roll_no]
      puts "Subject\t\t\t Marks\t\t Max\t\t Grade"
      puts '-----------------------------------------------------------------'
      result = 'Pass'
      grace_conut = 0
      (0...student_marks.size).each do |j|
        grace_conut += 1 if student_marks[j] < 33
      end
      (0...student_marks.size).each do |i|
        case student_marks[i]
        when ((maximum_no[i].to_i * 75) / 100)..maximum_no[i] then grade = 'A'
        when ((maximum_no[i].to_i * 45) / 100)...((maximum_no[i].to_i * 75) / 100) then grade = 'B'
        when ((maximum_no[i].to_i * 33) / 100)...((maximum_no[i].to_i * 45) / 100) then grade = 'C'
        when ((maximum_no[i].to_i * 28) / 100)...((maximum_no[i].to_i * 33) / 100)
          if grace_conut <= 1
            grace_conut += 1
            grade = 'Grace'
          else
            grade = 'Fail'
            result = 'Fail'
          end
        else

          grade = 'Fail'
          result = 'Fail'
        end
        puts "#{students_subject[i]}\t\t:\t #{student_marks[i]}\t:\t #{maximum_no[i]}\t:\t #{grade}\t:"
      end
      puts '-----------------------------------------------------------------'
      percentage = ((student_marks.sum * 100) / maximum_no.sum).to_f
      puts "Grant Total --> #{student_marks.sum} out of #{maximum_no.sum}\tPercentage --> #{percentage}%  #{result}"
    end
    repeat
  end

  @student_sub_count = 0
  def enter_subjact
    print "Subject Name\t:\tMaximum\n"
    (0...@student_sub_count).each do |i|
      $student_subject[i] = gets.chomp
      print "\t\t:\t"
      $max_no[i] = gets.to_i
      if ($max_no[i]).zero?
        puts 'Please Enter A Decimal No.'
        redo
      end
    end
    if @student_sub_count == 6
      puts 'Welcome to Calss 10th Result Portal'
    else
      puts 'Welcome to Calss 12th Result Portal'
    end
    create_marksheet
  end

  def create_marksheet
    print 'Enter Roll No.  :  '
    roll_no = gets.to_i
    print "Enter Name   \t:\t"
    name = gets.chomp
    $students[roll_no] = name
    student_marks = []
    print "Subject Name\t\t:\tMarks\n"
    (0...$student_subject.size).each do |i|
      print "#{$student_subject[i]}\t\t\t:\t"
      subject_mark = gets.to_i
      if (1..$max_no[i]).include?(subject_mark)
        student_marks[i] = subject_mark
      else
        puts "Please Enter correct no. Between 0 to #{$max_no[i]} "
        redo
      end
    end
    percentage = ((student_marks.sum * 100) / $max_no.sum).to_f
    puts "Grant Total --> #{student_marks.sum} out of #{$max_no.sum}\tPercentage --> #{percentage}%"
    $marks[roll_no] = student_marks
    $subject[roll_no] = $student_subject
    $max[roll_no] = $max_no
    repeat
  end

  def show_detail
    puts "Roll No.\t\t Name"
    puts '-----------------------------------------'
    $students.each do |key, value|
      print key, "\t\t:\t ", value, "\t\t:\n"
    end
    puts '-----------------------------------------'
    repeat
  end

  def repeat
    print "1.\tshow MarkSheet\n2.\tResult\n3.\tShow Students\n4.\tExit\nEnter any no. :  "
    enter_no = gets.to_i
    case enter_no
    when 1 then show_marksheet
    when 2
      print "1.\tClass 10th\n2.\tClass 12th\n3.\tBack\nEnter any no. :  "
      enter_2nd_no = gets.to_i
      case enter_2nd_no
      when 1
        @student_sub_count = 6
        $student_subject.clear
        $max_no.clear
        enter_subjact
      when 2
        @student_sub_count = 5
        $student_subject.clear
        $max_no.clear
        enter_subjact
      when 3 then repeat
      else
        puts 'Plese enter correct no.'
        repeat
      end
    when 3 then show_detail
    when 4 then puts 'Thank You'
    else
      puts 'Plese enter correct no.'
      repeat
    end
  end
end

marksheet = Marksheet.new
marksheet.repeat
