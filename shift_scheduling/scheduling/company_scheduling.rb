# frozen_string_literal: true

require 'byebug'
class Company
  $employees = []
  $shifts = []
  $shifts_scheduling = []
  $position = %w[developer tester]
  $days = {
    '0' => 'Sunday',
    '1' => 'Monday',
    '2' => 'Tuesday',
    '3' => 'Wednesday',
    '4' => 'Thursday',
    '5' => 'Friday',
    '6' => 'Saturday'
  }

  def run
    loop do
      print 'Enter Company Name :  '
      @name = gets.chomp
      if @name == ''
        print 'Please '
        redo
      else
        add_show_employee
        break
      end
    end
  end

  def add_show_employee
    puts "======================Welcome #{@name}======================="
    puts 'Enter 1 for add Shift.'
    puts 'Enter 2 for add Employee.'
    puts 'Enter 3 for show all Employee..'
    puts 'Enter 4 for find Employee and their availbilty.'
    puts 'Enter 5 for show all shifts'
    puts 'Enter 6 for find specific shift for its schedule.'
    puts 'Enter 7 for Exit.'
    puts '==================================================='
    option = gets.chomp.to_i
    case option
    when 1
      add_shift
    when 2
      add_employee
    when 3
      show_all_employee
    when 4
      find_employee
    when 5
      show_all_shifts
    when 6
      find_shift
    when 7
      puts "============Close of #{@name}============="
      exit
    else
      puts 'Pelese enter correct no between 1 to 6 '
      add_show_employee
    end
  end

  def add_employee
    if $shifts.empty?
      puts "Please add Shift first.\n\n"
      add_show_employee
    end
    id	= "EMP#{$employees.length}"
    employee_hash = {}
    employee_hash['employee_id'] = id
    loop do
      print 'Enter Employee name  :  '
      employee_hash['name'] = gets.chomp
      break unless employee_hash['name'] == ''

      print 'Please '
      redo
    end
    loop do
      puts 'Select option for position '
      puts '1. for developer'
      puts '2. for tester'
      option = gets.chomp.to_i
      case option
      when 1
        employee_hash['position'] = 'developer'
        puts 'you select developer'
      when 2
        employee_hash['position'] = 'tester'
        puts 'you select tester'
      else
        puts 'you enter wrong key'
        redo
      end
      break
    end
    employee_hash['timming'] = {}
    $days.each do |_key, value|
      print "Press Y or y for available and N or n for not available for #{value}  :  "
      yes = gets.chomp
      if %w[Y y].include?(yes)
        puts "Enter availbilty of #{value} for example and between 0-24 in hrs"
        employee_hash['timming'][value.to_s] = gets.chomp.to_s.split('-').map(&:strip).map(&:to_i)
        if employee_hash['timming'][value.to_s].length <= 1
          puts 'You enter wrong timming ......'
          puts 'Please enter time in range of 0-24'
          redo
        elsif employee_hash['timming'][value.to_s].max.zero? || (employee_hash['timming'][value.to_s].max > 24) || (employee_hash['timming'][value][0] > employee_hash['timming'][value][1])
          puts 'You enter wrong timming ......'
          puts 'Please enter time in range of 0-24'
          redo
        end
      elsif !%w[n N].include?(yes)
        puts 'You enter wrong key ......'
        puts 'Pelese enter Y or y and N or n'
        redo
      end
    end
    $employees << employee_hash
    puts "\n----------Done----------\n"
    scheduling(employee_hash)
    add_show_employee
  end

  def add_shift
    id = $shifts.length.to_s
    shift_hash = {}
    shift_hash['shift_id'] = id
    loop do
      print 'Enter Shift name  :  '
      shift_hash['shift_name'] = gets.chomp
      break unless shift_hash['shift_name'] == ''

      print 'Please '
      redo
    end
    loop do
      puts 'Enter timming between 0-24 in hrs'
      shift_hash['timming'] = gets.chomp.to_s.split('-').map(&:strip).map(&:to_i)
      if shift_hash['timming'].length <= 1
        puts 'You enter wrong timming ......'
        puts 'Please enter time in range of 0-24'
        redo
      elsif shift_hash['timming'].max.zero? || shift_hash['timming'].max > 24 || shift_hash['timming'][0] > shift_hash['timming'][1]
        puts 'You enter wrong timming ......'
        puts 'Please enter time in range of 0-24'
        redo
      else
        check_timming = false
        (0...$shifts.length).each do |i|
          shift_min = $shifts[i]['timming'].min
          shift_max = $shifts[i]['timming'].max
          check_timming = true if shift_min < shift_hash['timming'].min && shift_hash['timming'].min < shift_max
        end
        shift = $shifts.detect { |value| value['timming'] == shift_hash['timming'] }
        if !shift.nil? || check_timming
          puts "You can't enter same timming"
          puts "\n----------Faild----------\n"
          add_show_employee
        end
      end
      break
    end
    $shifts << shift_hash
    puts "\n----------Done----------\n"
    add_show_employee
  end

  def show_all_employee
    if	$employees.empty?
      puts 'No Employee are available.'
    else
      puts "EmployeeId\t\tName\t\tPositions"
      $employees.each do |value|
        puts "#{value['employee_id']}\t\t\t#{value['name']}\t\t\t#{value['position']}"
      end
    end
    add_show_employee
  end

  def find_employee
    if $employees.empty?
      puts 'No Employee are available.'
      add_show_employee
    end
    puts 'Enter Employee id'
    emp_id = gets.chomp.strip
    employee = $employees.detect { |value| emp_id == value['employee_id'] }
    if employee.nil?
      puts 'No Employee is found'
      find_employee
    else
      puts "EmployeeId:\t\t\t#{employee['employee_id']}"
      puts "Name:\t\t\t\t#{employee['name']}"
      puts "Positions:\t\t\t#{employee['position']}\n"
      puts "================== Start Availabilty ==========\n"
      puts "Day\t\tstart time\t\t  end time\n"
      employee['timming'].each do |key, value|
        if value.empty?
          puts "#{key}\t\t\tNot available"
        else
          puts "#{key}\t\t\t#{value.min}\t\t\t#{value.max}"
        end
      end
    end
    puts "================== End Availabilty ============\n"
    add_show_employee
  end

  def show_all_shifts
    if $shifts.empty?
      puts 'No Shift are available.'
    else
      puts "ShiftId\t\tName\t\tStart time\t\tEnd time"
      $shifts.each do |value|
        puts "#{value['shift_id']}\t\t#{value['shift_name']}\t\t#{value['timming'].min}\t\t\t#{value['timming'].max}"
      end
    end
    add_show_employee
  end

  def find_shift
    shift = []
    puts 'Enter Shift id'
    @shiftid = gets.chomp.to_s
    shift = $shifts.detect { |value| @shiftid.to_i == value['shift_id'].to_i }
    if shift.nil?
      puts "No Shift is found\n"
      find_shift
    elsif @shiftid == ''
      puts "Please Enter Shift id\n"
      find_shift
    else
      show_detail(shift)
    end
    add_show_employee
  end

  def show_detail(shift)
    puts "ShiftId:\t\t\t #{shift['shift_id']}"
    puts "Name:\t\t\t #{shift['shift_name']}"
    puts "Start Time:\t\t\t #{shift['timming'].min}"
    puts "End Time:\t\t\t #{shift['timming'].max}"
    puts "ShiftID\t\tEmployee id and name\t\tEmployee Position"
    $days.each do |_key, value|
      puts "==================Schedules for #{value} =========="
      shift_days  = $shifts_scheduling.select { |days| days['day'] == value && days['shift_id'] == @shiftid.to_s }
      shift_days.each do |s_days|
        start_time = s_days['timming'].min
        end_time = s_days['timming'].max
        if start_time != end_time
          puts "#{s_days['shift_name']}\t\t#{s_days['emp_name']}  #{start_time} - #{end_time}\t\t#{s_days['position']}"
          puts "\n"
        end
      end
      $position.each do |_position|
        puts "#{shift['shift_name']}\t\tNo worker scheduled" if shift_days.length.zero?
      end
    end
    puts '==================END Schedules =========='
  end

  def scheduling(employee_hash)
    total_hours = 0
    availablities = employee_hash['timming']
    availablities.each do |day, value|
      total_day_hours = 0
      next if value.empty?

      time_s = 0
      time_e = 0
      start_time = value.min
      end_time = value.max
      (0...$shifts.length).each do |i|
        if total_hours <= 40 || total_day_hours <= 10
          shift_start = 0
          shift_end = 0
          time_s = $shifts[i]['timming'].min
          time_e = $shifts[i]['timming'].max
          if start_time >= time_s && time_e > start_time && end_time <= time_e
            shift_start = start_time
            shift_end = end_time
            total_hours += (shift_end - shift_start)
            total_day_hours += (shift_end - shift_start)
            if total_hours > 40
              check_hours = total_hours - 40
              shift_end -= check_hours
              total_hours -= check_hours
              total_day_hours -= check_hours
            end
            if total_day_hours > 10
              check_day_hours = total_day_hours - 10
              shift_end -= check_day_hours
              start_time = shift_end + 10
              total_hours -= check_day_hours
              total_day_hours = 0
            end
          elsif end_time >= time_e
            shift_start = start_time
            if end_time <= time_e
              shift_end = end_time
            else
              shift_end = time_e
              start_time = time_e
            end
            total_hours += (shift_end - shift_start)
            total_day_hours += (shift_end - shift_start)
            if total_hours > 40
              check_hours = total_hours - 40
              shift_end -= check_hours
              total_hours -= check_hours
              total_day_hours -= check_hours
            end
            if total_day_hours > 10
              check_day_hours = total_day_hours - 10
              shift_end -= check_day_hours
              start_time = shift_end + 10
              total_hours -= check_day_hours
              total_day_hours = 0
            end
          end
        end
        scheduling_hash = {}
        scheduling_hash['day'] = day
        scheduling_hash['timming'] = [shift_start, shift_end]
        scheduling_hash['shift_id'] = $shifts[i]['shift_id']
        scheduling_hash['shift_name'] = $shifts[i]['shift_name']
        scheduling_hash['emp_name'] = employee_hash['name']
        scheduling_hash['position'] = employee_hash['position']
        $shifts_scheduling << scheduling_hash
      end
    end
    add_show_employee
  end
end
company = Company.new
company.run
