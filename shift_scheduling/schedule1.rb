# frozen_string_literal: true

require 'byebug'
module GetDetail
  def get_detail
    name = ''
    loop do
      name = gets.chomp.to_s
      break unless name == ''
    end
    name
  end
end

module GetAvailability
  def get_available_from(availabilty)
    puts "Enter availbilty of #{availabilty} for example and between 00:01  - 23:59 in hrs)"
    gets.chomp.to_s.split('-').map(&:strip)
  end
end

class Shift
  include GetDetail
  include GetAvailability
  attr_accessor :shift_id, :name, :start_time, :end_time, :wqwp

  def initialize(shift_id, name, start_time, end_time, arg)
    # def initialize
    # add_shift_name
    # shift_timings
    @shift_id = shift_id
    @name = name
    @start_time = start_time
    @end_time = end_time
    # position and their quantity
    @wqwp = arg || {}
    # add_position_and_quantity

    # shift scheduling with worker availability
    @shift_scheduling = {}
  end

  def minimum_details
    puts "#{@shift_id}\t\t#{@name}\t\t#{@start_time}\t\t#{@start_time}"
  end

  def show_detail
    puts "ShiftId:\t\t\t #{@worker_id}"
    puts "Name:\t\t\t #{@name}"
    puts '================== Worker required for position in this shift =========='
    puts "Positions\t\t\tQuantity"
    @wqwp.each do |k, v|
      puts "#{k}\t\t\t\t#{v}"
    end
    puts '================== End quantity with position ============'
  end

  def add_shift_name
    puts 'enter the shift name'
    @name = get_detail
  end

  def shift_timings
    @start_time, @end_time = get_available_from('shift')
  end

  def add_position_and_quantity
    puts 'Enter quantity according to position'
    puts 'Note:- enter 0 or any key(alpha) for no position in the shift'
    Position.instance.each do |position|
      puts "Please enter quantity for #{position}"
      @wqwp[position] = gets.chomp.to_i
    end
  end
end

class Position
  def self.add_positions
    positions = []
    loop do
      puts 'enter all positions seprated with comma '
      position = gets.chomp.to_s.strip
      if position != ''
        positions = position.split(',').map(&:strip).uniq
        break
      else
        puts 'Positions should not be blank'
      end
    end
    positions
  end

  def self.instance
    @positions ||= %w[a s m f z] # add_positions
  end
end

class WorkerAvailability
  include GetAvailability
  DAYS = {
    '0' => 'Sunday',
    '1' => 'Monday',
    '2' => 'Tuesday',
    '3' => 'Wednesday',
    '4' => 'Thursday',
    '5' => 'friday',
    '6' => 'Saturday'
  }.freeze
  attr_accessor :day, :available_from, :till_available, :available

  def initialize(day, available, start_t)
    @day = day
    @available = available # get_available
    return unless @available == 'Y' || @available == 'y'

    @available_from, @till_available = start_t # get_available_from("worker")
  end

  def get_available
    puts "Press Y or y for available for #{DAYS[@day]}"
    available = gets.chomp.to_s
  end

  def display
    if %w[Y y].include?(@available)
      puts "#{DAYS[@day]}\t\t   #{@available_from}\t\t\t  #{@till_available}"
    else
      puts "#{DAYS[@day]}\t\t\t  Not Available"
    end
  end
end

class Worker
  include GetDetail
  attr_accessor :worker_id

  def initialize(worker_id, arg)
    @worker_id = "RSI#{worker_id}"
    @name = arg[:name] || ''
    @current_positions = arg[:current_positions] || []
    @availablities = []
    return if arg[:availablities].nil?

    arg[:availablities].each do |a|
      @availablities << WorkerAvailability.new(a[:day], a[:available], a[:start_t])
    end

    # start
  end

  def start
    add_worker_details
    add_current_positions
    add_availabilities
  end

  def add_worker_details
    puts 'Enter worker name'
    @name = get_detail
  end

  def add_current_positions
    puts "Enter positions at least one or multiple with seprated with comma from #{Position.instance.join(',')}"
    loop do
      positions = gets.chomp.split(',').map(&:strip)
      if positions.map { |position| Position.instance.include?(position) }.include?(false)
        puts 'Enter correct position or entered position should be uniq'
      else
        @current_positions << positions
        break
      end
    end
  end

  def add_availabilities
    puts 'Enter availabilities for weeks'
    WorkerAvailability::DAYS.each do |k, _v|
      @availablities << WorkerAvailability.new(k)
    end
  end

  def minimum_details
    puts "#{@worker_id}\t\t#{@name}\t\t#{@current_positions.join(',')}"
  end

  def show_detail
    puts "WorkerId:\t\t\t #{@worker_id}"
    puts "Name:\t\t\t #{@name}"
    puts "Positions:\t\t\t #{@current_positions.join(',')}"
    puts '================== Start Availabilty =========='
    if @availablities.empty?
      puts 'Not available for this week'
    else
      puts "Day\t\t start time \t\t  end time"
      @availablities.each do |work_availibilty|
        puts work_availibilty.display
      end
    end
    puts '================== End Availabilty ============'
  end
end

class Restuarent
  include GetDetail
  attr_accessor :name, :shifts, :workers

  def initialize
    @workers = []
    @shifts = []
  end

  def run
    puts 'Enter Restuarent Name'
    @name = 'mohan' # get_detail
    puts "======================Welcome #{@name}======================="
    puts Position.instance
    # add_shifts
    @workers = []
    dummy_data
    add_worker_and_schedule
  end

  def dummy_data
    @shifts << Shift.new(@shifts.length, 'morning', 8, 13, { 'a' => 1, 's' => 2, 'm' => 2, 'f' => 2, 'z' => 2 })
    @shifts << Shift.new(@shifts.length, 'eveninig', 9, 21, { 'a' => 2, 's' => 2, 'm' => 2, 'f' => 2, 'z' => 2 })
    @workers <<	Worker.new(@workers.length, { name: 'j', current_positions: %w[a s m], availablities: [
                             { day: '0', available: 'Y', start_t: [9, 15] },
                             { day: '3', available: 'Y', start_t: [9, 15] },
                             { day: '1', available: 'Y', start_t: [9, 15] },
                             { day: '2', available: 'Y', start_t: [9, 15] },
                             { day: '4', available: 'Y', start_t: [9, 15] },
                             { day: '5', available: 'Y', start_t: [9, 15] },
                             { day: '6', available: 'n', start_t: [9, 15] }
                           ] })
    @workers <<	Worker.new(@workers.length, { name: 'k', current_positions: %w[a m], availablities: [
                             { day: '0', available: 'Y', start_t: [9, 17] },
                             { day: '1', available: 'Y', start_t: [9, 17] },
                             { day: '2', available: 'n', start_t: [9, 17] },
                             { day: '3', available: 'Y', start_t: [9, 17] },
                             { day: '4', available: 'Y', start_t: [9, 17] },
                             { day: '5', available: 'Y', start_t: [9, 17] },
                             { day: '6', available: 'n', start_t: [9, 17] }
                           ] })
  end

  def add_shifts
    loop do
      puts 'how many shifts do you want in a day'
      shift = gets.chomp.to_i
      next unless shift != 0 && shift < 12

      shift.times do
        @shifts << Shift.new
      end
      break
    end
  end

  def add_workers
    loop do
      puts 'Enter the worker'
      @workers <<	Worker.new(@workers.length, {})
      puts 'Enter Y to continue to add worker'
      break unless ['Y'].include?(gets.chomp.to_s)
    end
  end

  def show_all_workers
    if @workers.empty?
      puts 'No workers are available.'
    else
      puts "workerId\t\tName\t\tPositions"
      @workers.each(&:minimum_details)
    end
  end

  def find_worker
    puts 'Enter worker id'
    worker_id = gets.chomp.strip
    worker = @workers.find { |worker| worker.worker_id.downcase == worker_id.downcase }
    if worker.nil?
      puts 'No worker is found'
    else
      worker.show_detail
    end
  end

  def show_all_shifts
    if @shifts.empty?
      puts 'No shifts are available for this week.'
    else
      puts "shiftId\t\tName\t\tstart time\t end time"
      @shifts.each(&:minimum_details)
    end
  end

  def find_shift
    puts 'Enter shift id'
    shift_id = gets.chomp.strip.to_i
    shift = @shifts.find { |worker| worker.shift_id == shift_id }
    if shift.nil?
      puts 'No shift is found'
    else
      shift.show_detail
    end
  end

  def add_worker_and_schedule
    loop do
      puts '==================================================='
      puts 'Enter 1 for add worker.'
      puts 'Enter 2 for show all workers.'
      puts 'Enter 3 for find worker and their availbilty.'
      puts 'Enter 4 for show all shifts'
      puts 'Enter 5 for show specific shift for its schedule.'
      puts 'Enter 6 for Exit.'
      puts '==================================================='
      option = gets.chomp.to_i
      case option
      when 1
        add_workers
      when 2
        show_all_workers
      when 3
        find_worker
      when 4
        show_all_shifts
      when 5
        find_shift
      when 6
        puts "============close of #{@name}============="
        break
      end
    end
  end
end

restuatent = Restuarent.new
restuatent.run
