# frozen_string_literal: true

require 'byebug'
class Company
  # $employee = Hash["EMP0"=>["@employee_name"=>"Mahesh","@position"=>"dev","@available"=> ['0'=>"y",'1'=>"y",'2'=>"y",'3'=>"y",'4'=>"y",'5'=>"y",'6'=>"y"],
  #							"@timming"=>['0'=>10..12,'1'=>10..12,'2'=>10..12,'3'=>10..12,'4'=>10..12,'5'=>10..12]]]
  $employee = { 'id' => ['EMP1' => ['name' => 'user1', 'position' => 'dev']] }
  $available = { 'EMP1' => ['0' => 'y', '1' => 'y', '2' => 'y', '3' => 'y', '4' => 'y', '5' => 'y', '6' => 'y'] }
  $timming = { 'EMP1' => ['0' => [10,
                                  12], '1' => [10,
                                               12], '2' => [10,
                                                            12], '3' => [10, 12], '4' => [10, 12], '5' => [10, 12]] }

  $days = {
    '0' => 'Sunday',
    '1' => 'Monday',
    '2' => 'Tuesday',
    '3' => 'Wednesday',
    '4' => 'Thursday',
    '5' => 'friday',
    '6' => 'Saturday'
  }
  # $employee = Hash["workers_hahs" => []]
  # $shifts = Hash["shifts_hash" => []]

  def run
    loop do
      print 'Enter Company Name :  '
      @name = gets.chomp
      if @name == ''
        print 'Pelese '
        redo
      else
        add_show_employee
        break
      end
    end
  end

  def add_show_employee
    puts "======================Welcome #{@name}======================="

    # puts "==================================================="
    puts 'Enter 1 for add Employee.'
    puts 'Enter 2 for show all Employee.'
    puts 'Enter 3 for find Employee and their availbilty.'
    puts 'Enter 4 for show all shifts'
    puts 'Enter 5 for find specific shift for its schedule.'
    puts 'Enter 6 for Exit.'
    puts '==================================================='
    option = gets.chomp.to_i
    case option
    when 1
      add_employee
    when 2
      show_all_employe
    when 3
      # find_worker
    when 4
      show_all_shifts
    when 5
      # find_shift
    when 6
      puts "============Close of #{@name}============="
      exit
    else
      puts 'Pelese enter correct no between 1 to 6 '
      add_show_employee
    end
  end

  def add_employee
    employee_id = "EMP#{$employee.length + 1}"
    employee_hash = {}
    available = {}
    timming = {}
    while true
      print 'Enter Employee name  :  '
      employee_name = gets.chomp
      break unless employee_name == ''

      print 'Pelese '
      redo

    end
    print 'Enter Employee position  :  '
    position = gets.chomp
    $days.each do |key, values|
      print "Press Y or y for available and N or n for not available for #{values}  :  "
      yes = gets.chomp
      if %w[Y y].include?(yes)
        available[key] = yes
        puts "Enter availbilty of #{values} for example and between 0-24 in hrs"
        timming[key] = gets.chomp.to_s
        timming[key] = timming[key].split('-').map(&:strip).map(&:to_i)
        if timming[key].max.zero? || (timming[key].max > 24)
          puts 'You enter wrong timming ......'
          puts 'Pelese enter time in range of 0-24'
          redo
        end
      elsif !%w[n N].include?(yes)
        puts 'You enter wrong key ......'
        puts 'Pelese enter Y or y and N or n'
        redo
      end
    end
    # byebug
    $employee['id'] = employee_id
    $employee['name'] = employee_name
    $employee['position'] = position
    $available[employee_id] = available
    $timming[employee_id] = timming
    # byebug
    available.each do |key, values|
      puts "#{key} & #{values}"
    end

    add_show_employee
  end

  def show_all_employe
    # byebug
    if	$employee.empty?
      puts 'No Employee are available.'
    else
      puts "EmployeeId\t\tName\t\tPositions"
      $employee.each do |_id|
        # byebug
        puts ($employee['id']).to_s
      end
      add_show_employee
    end
  end

  def show_all_shifts
    # byebug
    if	$shift.empty?
      puts 'No Shift are available.'
    else
      puts "ShiftId\t\tShiftName\t\tStartTime\t\tEndTime"
      $shift.each do |_id|
        # byebug
        puts ($shift['id']).to_s
      end
      add_show_employee
    end
  end
end
company = Company.new
company.run
