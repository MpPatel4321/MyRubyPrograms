# frozen_string_literal: true

require 'byebug'
require 'time'

class Schedule
  attr_reader :employees_list, :shifts

  POSITIONS = %w[cook cleaning].freeze
  WEEKDAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze

  def initialize
    @scheduled_shifts = []
    @employees_list = []
    @shifts = []
  end

  def run
    puts '============================================='
    puts 'Enter 1 to add Shift.'
    puts 'Enter 2 to show Shift'
    puts 'Enter 3 to add Employee.'
    puts 'Enter 4 to Show Employee.'
    puts 'Enter 5 to show Shift scheduled'
    puts 'Enter 6 to assign employee in Shift'
    puts 'Enter 7 for Exit.'
    puts '============================================='
    option = gets.chomp.to_i
    case option
    when 7
      exit
    when 1
      add_new_shift
    when 2
      all_shifts
    when 3
      add_new_employee
    when 4
      employee_lists
    when 5
      find_shift_scheduled
    when 6
      assign_employee_to_shift
    else
      puts 'Pelese enter correct no between 1 to 6 '
      run
    end
  end

  private

  def find_shift_scheduled
    shift_id = find_valid_shift
    display_assigned_shifts(shift_id)
    run
  end

  # Display Shift Scheduled
  def display_assigned_shifts(shift_id)
    shift_scheduled = get_scheduled_shift(shift_id)

    display_shift_details(shift_scheduled[:id])

    puts '-------------------------------------------------------------'

    shift_scheduled[:scheduled].each do |key, value|
      puts key
      value.each do |position, employees|
        puts "Position: #{position}"
        puts "\tNo Employee Assigned" if employees.empty?
        employees.each do |employee|
          puts "\tEmployees Assigned"
          employee.each do |employee_id, time|
            emp = get_employee(employee_id.to_i)
            puts "\tName:\t\t #{emp['name']}"
            puts "\tStart Time:\t #{time[:start_time]}"
            puts "\tEnd Time:\t #{time[:end_time]}"
          end
        end
      end
      puts '-------------------------------------------------------------'
    end
  end

  # Find a shift by shift Id
  def get_shift(id)
    @shifts.select { |shift| shift[:id] == id.to_s }.first
  end

  def get_employee(id)
    @employees_list.select { |employee| employee[:id] == id || employee['id'] == id }.first
  end

  def get_scheduled_shift(id)
    @scheduled_shifts.select { |ss| ss[:id] == id }.first
  end

  # Print Shifts
  def display_shift_details(shift_id)
    puts '=================Shift Detail================='
    shift = get_shift(shift_id)
    puts "* Name: #{shift[:name]}"
    puts "* Start Time: #{shift[:start_time]}"
    puts "* Start Time: #{shift[:end_time]}"
    puts '* Positions: '
    shift[:positions].each do |key, value|
      puts "*\t#{key}: #{value}"
    end
    puts '=============================================='
    puts ''
  end

  def display_employee_details(employee_id)
    puts '=================Shift Detail================='
    shift = get_employee(employee_id)
    puts "* Name: #{shift[:name]}"
    puts '=============================================='
    puts ''
  end

  def initialize_shift_scheduling(shift_id)
    shift = get_shift(shift_id)
    hash = {}
    hash[:id] = shift_id
    hash[:scheduled] = {}
    WEEKDAYS.each do |week_day|
      hash[:scheduled][week_day] = {}
      shift[:positions].each do |key, _value|
        hash[:scheduled][week_day][key] = []
      end
    end
    @scheduled_shifts << hash
  end

  def find_valid_shift
    puts 'Enter Shift id'
    shift_id = gets.chomp.to_i
    scheduled_shift = get_scheduled_shift(shift_id)

    return shift_id unless scheduled_shift.nil?

    puts "Error: Can't find any shift with ID: #{shift_id}"
    find_valid_shift
  end

  def add_new_shift
    i = 1
    loop do
      puts 'Would you like to add shift? [y/n]: '
      begin
        case gets.strip
        when 'Y', 'y', 'yes'
          puts 'Enter name of shift :'
          shift_name = gets.chomp
          puts 'Enter start time in this format hh:mm:ss :'
          get_start_time = gets.chomp
          # get_start_time = '00:00:00'
          start_time = Time.parse(get_start_time).strftime('%H:%M:%S')
          puts 'Enter end time in this format hh:mm:ss:'
          end_time = gets.chomp # '12:00:00'
          end_time = Time.parse(end_time).strftime('%H:%M:%S')
          while end_time <= start_time
            puts 'End time should be greater than to start time, please enter valid end time'
            end_time = gets.chomp
            end_time = Time.parse(end_time).strftime('%H:%M:%S')
          end
          is_overlapped = false
          @shifts&.each do |shift|
            next unless start_time < shift[:end_time] && end_time > shift[:start_time]

            puts 'Shift already created please take another slot'
            i -= 1
            is_overlapped = true
            break
          end
          position_worker_name = assigin_positions_to_shift unless is_overlapped
          unless is_overlapped
            @shifts << { id: i.to_s, "name": shift_name, "start_time": start_time, "end_time": end_time,
                         positions: position_worker_name }
          end
          initialize_shift_scheduling(i)
          i += 1
        when /\A[nN]o?\Z/ # n or no
          break
        end
      rescue StandardError => e
        puts e
        redo
      end
    end
    run
  end

  def assigin_positions_to_shift
    postition_worker_name = {}
    POSITIONS.each do |position|
      puts "Enter number of worker for  #{position}:"
      position_number = gets.chomp.to_s.to_i
      postition_worker_name[position] = position_number
    end
    postition_worker_name
  end

  def add_new_employee
    emp_id = 0
    loop do
      puts 'Would you like to add emplpyee? [y/n]: '
      begin
        case gets.strip
        when 'Y', 'y', 'j', 'J', 'yes' # j for Germans (Ja)
          emplpyee_hash = {}
          emplpyee_hash['id'] = emp_id + 1
          puts 'Enter name of the emplpyee:'
          emplpyee_name = gets.chomp
          emplpyee_hash['name'] = emplpyee_name
          puts 'Enter positions for emplpyee:'
          positions = []
          POSITIONS.each do |position|
            puts "do you want to add this for #{position}? [y/n]: "
            case gets.strip
            when 'Y', 'y', 'j', 'J', 'yes' # j for Germans (Ja)
              positions << position
            when /\A[nN]o?\Z/ # n or no
              next
            end
          end
          emplpyee_hash['worked_hours'] = 0
          emplpyee_hash['positions'] = positions
        when /\A[nN]o?\Z/ # n or no
          break
        end
        emp_id = emplpyee_hash['id']
        @employees_list << emplpyee_hash
      rescue StandardError => e
        puts e
        redo
      end
    end
    run
  end

  # Print Employees
  def employee_lists
    puts '=================Employee List================='
    puts '=================No Employees Found=================' if @employees_list.empty?
    @employees_list.each do |worker|
      puts "* EmpID       #{worker['id']}"
      puts "* EmpName     #{worker['name']}"
      puts "* WorkedHours #{worker['worked_hours']}"
      puts "* Positions   #{worker['positions'].join(',')}"
      puts '--------------------------------------------'
    end
    run
  end

  # Print Shifts List
  def all_shifts
    puts '=================Shift List================='
    @shifts.each do |shift|
      puts "* ID: #{shift[:id]}"
      puts "* Name: #{shift[:name]}"
      puts "* Start Time: #{shift[:start_time]}"
      puts "* End Time:   #{shift[:end_time]}"
      puts '* Positions: '
      shift[:positions].each do |key, value|
        puts "*\t#{key}: #{value}"
      end
      puts '=============================================='
      puts ''
    end
    run
  end

  def assign_employee_to_shift(shift_id = nil)
    shift_id = find_valid_shift if shift_id.nil?
    shift = get_shift(shift_id)
    puts "=======#{shift_id}======="

    shift_scheduled = get_scheduled_shift(shift_id)
    hash = shift_scheduled[:scheduled]
    shift_scheduled[:scheduled].each do |key, value|
      puts key
      value.each do |position, employees|
        available_employees = available_employees_by_positions(position, employees)
        puts "Assign Employees for #{key} For #{position} Position"
        puts "\t\tAvailable Employees:"
        available_employees.map do |c|
          puts "\t\tID: #{c['id']}, Name: #{c['name']}, available time: #{40 - c['worked_hours']}"
        end
        hash[key][position] = []
        if available_employees == []
          hash[key][position] = []
        else
          while shift[:positions][position]
            puts 'Would you like to add emplpyee? [y/n]:'
            case gets.strip
            when 'Y', 'y', 'j', 'J', 'yes' # j for Germans (Ja)
              employee_id, start_time, end_time = get_employee_details(available_employees, shift[:start_time],
                                                                       shift[:end_time], hash[key][position])
              hash[key][position] << { employee_id => { start_time: start_time.to_i, end_time: end_time.to_i } }
            when /\A[nN]o?\Z/ # n or no
              break
            end
          end
        end
      end
      puts '-------------------------------------------------------------'
    end
    run
  end

  def get_employee_details(available_employees, shift_st, shift_et, assigned_employees)
    shift_st = shift_st.to_i
    shift_et = shift_et.to_i
    puts 'Please enter Employee ID'
    employee_id = gets.chomp

    while !assigned_employees.empty? && !assigned_employees.first.select { |c| c[employee_id] }.empty?
      puts "Employee with ID #{employee_id} already exits. Please enter other Employee id"
      employee_id = gets.chomp
    end

    while available_employees.select { |shift| shift['id'] == employee_id.to_i }.first.nil?
      puts 'Please enter a valid employee ID from available emplpyees list'
      employee_id = gets.chomp
    end

    puts "Please enter Start Time in between #{shift_st} to #{shift_et + 1}"
    start_time = gets.chomp

    until (start_time.to_i >= shift_st) && (start_time.to_i < shift_et)
      puts "time should be greater than #{shift_st} and less then #{shift_et + 1}"
      start_time = gets.chomp
    end

    puts "Please enter End Time in between #{start_time} to #{shift_et} And Employee worked hours should not be greater then 10"
    end_time = gets.chomp

    while !((end_time.to_i > shift_st) && (end_time.to_i <= shift_et) &&
            (end_time.to_i >= start_time.to_i)) || end_time.to_i - start_time.to_i > 10
      puts "Please enter End Time in between #{start_time} to #{shift_et} And Employee worked hours should not be greater then 10"
      end_time = gets.chomp
    end

    [employee_id, start_time, end_time]
  end

  def valid_employee_time(employee_id, hours)
    status = true
    employee = get_employee(employee_id)
    status = false if (40 - employee[:worked_hours].to_i - hours).positive?

    status
  end

  def available_employees_by_positions(position, _assigned_employees = [])
    @employees_list.select { |employee| employee['positions'].include?(position.to_s) && employee['worked_hours'] < 40 }
  end
end

schedule = Schedule.new
schedule.run
