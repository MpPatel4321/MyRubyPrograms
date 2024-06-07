# frozen_string_literal: true

require 'byebug'
class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def intersection(other)
    return nil if (max < other.begin) || (other.max < self.begin)

    [self.begin, other.begin].max..[max, other.max].min
  end
  alias & intersection

  def difference
    max - min
  end

  def -(other)
    return self if last < other.first

    out = []
    unless other.first <= first && other.last >= last
      out << Range.new(first, other.first) if other.first > first
      out << Range.new(other.last, last) if other.last < last
    end
    out
  end
end

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
    puts "Enter availbilty of #{availabilty} for example and between 0 - 24 in hrs)"
    gets.chomp.to_s.split('-').map(&:strip).map(&:to_i)
  end
end

class ShiftSchedule
  attr_accessor :shift, :shift_range, :day, :position, :scheduled_hours, :status, :rank, :vacant_hours

  def initialize(day, shift, position, rank, shift_range)
    @shift_range = shift_range
    @shift = shift
    @day = day
    @rank = rank
    @position = position
    # status should be vacant, scheduled or partially scheduled
    @status = 'vacant'
    @scheduled_hours = {}
    @vacant_hours = [@shift_range]
  end

  def assing_worker(worker, range)
    @scheduled_hours[worker] = range
    set_status
  end

  def set_status
    shift_difference = @shift_range.difference
    all_hours = @scheduled_hours.values.map(&:difference).sum
    if all_hours == shift_difference
      @status = 'scheduled'
    elsif all_hours < shift_difference
      @status = 'partially_scheduled'
    end
    available_time
  end

  def available_time
    if @status == 'partially_scheduled'
      @scheduled_hours.each_value do |range|
        @vacant_hours = @vacant_hours.map { |z| z - range }.flatten
      end
    end
    @vacant_hours
  end
end

class Shift
  include GetDetail
  include GetAvailability
  attr_accessor :shift_id, :name, :start_time, :end_time, :wqwp, :shift_schedules

  def initialize(shift_id)
    @shift_id = shift_id
    # add_shift_name
    # shift_timings
    # position and their quantity
    @wqwp = {}

    @shift_schedules = []

    # add_position_and_quantity
    # shift scheduling with worker availability
  end

  def initialize_dummy(arg)
    @name = arg[0]
    @start_time, @end_time = arg[1]
    Position.instance.each do |position|
      quantity = arg[2][position]
      next unless quantity != 0

      @wqwp[position] = quantity
      quantity.times.each do |p|
        WorkerAvailability::DAYS.each_key do |day|
          @shift_schedules << ShiftSchedule.new(day, @shift_id, position, p, range)
        end
      end
    end
    self
  end

  def minimum_details
    puts "#{@shift_id}\t\t#{@name}\t\t#{@start_time}\t\t#{@end_time}"
  end

  def show_detail
    puts "ShiftId:\t\t\t #{@shift_id}"
    puts "Name:\t\t\t #{@name}"
    puts "ShiftID\t\tWorker id and name\t\tWorker Position\tSchedule status"
    # byebug
    WorkerAvailability::DAYS.each do |key, day|
      puts "==================Schedules for #{day} =========="
      shift_schedules  = find_schedules(key)
      shift_schedules.each do |shift_schedule|
        if shift_schedule.status != 'vacant'
          worker = shift_schedule.scheduled_hours.map do |key, value|
            "#{key} :- #{value}"
          end.join(',')
          puts "#{shift_schedule.shift}\t\t#{worker}\t\t#{shift_schedule.position}\t\t#{shift_schedule.status}"
        else
          puts "#{shift_schedule.shift}\t\tNo worker scheduled\t\t#{shift_schedule.position}\t\t#{shift_schedule.status}"
        end
      end
      puts "\n"
    end
    # @wqwp.each do |k,v|
    # 	puts "#{k}\t\t\t\t#{v}"
    # end
    puts '==================END Schedules =========='
  end

  def add_shift_name
    puts 'enter the shift name'
    @name = get_detail
  end

  def shift_timings
    @start_time, @end_time = get_available_from('shift')
  end

  def add_position_and_quantity
    puts 'Enter quantity according to position in numric'
    puts 'Note:- enter 0 or any key(alpha) for no position in the shift'
    Position.instance.each do |position|
      puts "Please enter quantity for #{position}"
      quantity = gets.chomp.to_i
      next unless quantity != 0

      @wqwp[position] = quantity
      quantity.times.each do |p|
        WorkerAvailability::DAYS.each_key do |day|
          @shift_schedules << ShiftSchedule.new(day, @shift_id, position, p, range)
        end
      end
    end
  end

  def worker_schedule(worker)
    # total_work = 10
    # worker.availablities.each do |work_availibilty|
    # 	comman_range = range & work_availibilty.range
    # 		if !comman_range.nil? && comman_range.max != comman_range.min
    # 		 		total_work = total_work - (comman_range.max-comman_range.min)
    # 		 	else
    # 		 		break

    # 	end
    # end

    worker.availablities.each do |work_availibilty|
      break if worker.total_scheduled_hours >= 40 || worker.total_scheduled_hours >= 10

      next unless work_availibilty.can_available?(self)

      all_vacant_schedules = fetch_all_schedules(work_availibilty.day, worker.current_positions)
      next unless all_vacant_schedules.length.positive?

      comman_range = range & work_availibilty.range
      # byebug
      next unless !comman_range.nil? && comman_range.max != comman_range.min
      unless (worker.total_scheduled_hours + (comman_range.max - comman_range.min)) <= 40 || (worker.total_scheduled_hours + (comman_range.max - comman_range.min)) <= 10
        break
      end

      shift_schedule = all_vacant_schedules.first
      # total_work += (comman_range.max-comman_range.min)
      shift_schedule.assing_worker(worker.full_name, comman_range)
      worker.total_scheduled_hours = worker.total_scheduled_hours + (comman_range.max - comman_range.min)
      work_availibilty.remaining_hours -= (comman_range.max - comman_range.min)
      work_availibilty.consumed_hours -= (comman_range.max - comman_range.min)
    end
  end

  def fetch_all_schedules(day, positions)
    @shift_schedules.find_all do |shift_schedule|
      shift_schedule.day == day && shift_schedule.status != 'scheduled' && positions.include?(shift_schedule.position)
    end
  end

  def find_schedules(day)
    @shift_schedules.find_all { |shift_schedule| shift_schedule.day == day }
  end

  def range
    @start_time..@end_time
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
    @positions ||= %w[m f] # add_positions
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
  attr_accessor :day, :available_from, :till_available, :available, :consumed_hours, :remaining_hours, :vacant_hours,
                :worked_hours

  # def initialize(day)
  # 	@day = day
  # 	@consumed_hours = 0
  # 	@available = get_available
  # 	@remaining_hours = 0

  # 	if @available == 'Y' || @available == 'y'
  # 		@available_from, @till_available = get_available_from("worker")
  # 		@remaining_hours = @till_available - @available_from
  # 		@vacant_hours = [range]
  # 	end
  # 	@shifts_hours = {}
  # end

  def initialize(day, available, start_t)
    @day = day
    @consumed_hours = 0
    @remaining_hours = 0
    @available = available # get_available
    if @available == 'Y' || @available == 'y'
      @available_from, @till_available = start_t # get_available_from("worker")
      @remaining_hours = @till_available - @available_from
      @vacant_hours = [range]
    end
    @shifts_hours = {}
  end

  def can_available?(shift)
    return false unless %w[Y y].include?(@available)
    return false if @remaining_hours.zero?

    comman_range = shift.range & range
    if comman_range.nil?
      false
    else
      true
    end
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

  def range
    (@available_from..@till_available)
  end
end

class Worker
  include GetDetail
  attr_accessor :worker_id, :total_scheduled_hours, :availablities, :current_positions

  def initialize(worker_id)
    @worker_id = "RSI#{worker_id}"
    @total_scheduled_hours = 0
    @name = ''
    @current_positions = []
    @availablities = []
    # start
  end

  def initialize_dummy(arg)
    @name = arg[:name]
    @current_positions = arg[:current_positions]
    arg[:availablities].each do |available|
      @availablities << WorkerAvailability.new(available[:day], available[:available], available[:start_t])
    end
  end

  def full_name
    "#{@worker_id}  #{@name}"
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
        @current_positions = positions
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
    puts "#{@worker_id}\t\t#{@name}\t\t#{@current_positions.join(',')} \t\t #{@total_scheduled_hours}"
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
    @schedule = []
  end

  def run
    puts 'Enter Restuarent Name'
    @name = 'mohan' # get_detail
    puts "======================Welcome #{@name}======================="
    Position.instance
    # add_shifts
    @workers = []
    dummy_shifts
    add_worker_and_schedule
  end

  def dummy_shifts
    @shifts << Shift.new(@shifts.length).initialize_dummy(['first', [0, 8], { 'm' => 1, 'f' => 1 }])
    @shifts << Shift.new(@shifts.length).initialize_dummy(['second', [8, 16], { 'm' => 1, 'f' => 1 }])
    @shifts << Shift.new(@shifts.length).initialize_dummy(['third', [16, 24], { 'm' => 1, 'f' => 1 }])
    worker = Worker.new(@workers.length)
    worker.initialize_dummy({ name: 'mohan', current_positions: %w[m f], availablities: [
                              { day: '0', available: 'n', start_t: [6, 20] },
                              { day: '1', available: 'Y', start_t: [5, 20] },
                              { day: '2', available: 'n', start_t: [6, 20] },
                              { day: '3', available: 'n', start_t: [6, 20] },
                              { day: '4', available: 'n', start_t: [5, 16] },
                              { day: '5', available: 'n', start_t: [9, 15] },
                              { day: '6', available: 'n', start_t: [9, 15] }
                            ] })
    @workers << worker
    check_schedule(worker)

    # worker = Worker.new(@workers.length)
    # worker.initialize_dummy({name: "radhe", current_positions: ['m','f'], availablities: [
    #  	{day: '0', available: "Y", start_t: [9,21]},
    #  	{day: '3', available: "Y", start_t: [9,18]},
    #  	{day: '1', available: "Y", start_t: [9,18]},
    #  	{day: '2', available: "Y", start_t: [9,15]},
    #  	{day: '4', available: "Y", start_t: [9,18]},
    #  	{day: '5', available: "n", start_t: [9,18]},
    #  	{day: '6', available: "n", start_t: [9,15]}
    #  ]})
    #  @workers << worker
    #  check_schedule(worker)

    #  	worker = Worker.new(@workers.length)
    # worker.initialize_dummy({name: "radhe", current_positions: ['m','f'], availablities: [
    #  	{day: '0', available: "Y", start_t: [9,22]},
    #  	{day: '3', available: "Y", start_t: [9,18]},
    #  	{day: '1', available: "Y", start_t: [9,18]},
    #  	{day: '2', available: "Y", start_t: [9,15]},
    #  	{day: '4', available: "Y", start_t: [9,18]},
    #  	{day: '5', available: "n", start_t: [9,18]},
    #  	{day: '6', available: "n", start_t: [9,15]}
    #  ]})
    #  @workers << worker
    #  check_schedule(worker)
  end

  def add_shifts
    loop do
      puts 'how many shifts do you want in a day'
      shift = gets.chomp.to_i
      next unless shift != 0 && shift < 12

      shift.times do
        @shifts << Shift.new(@shifts.length)
      end
      break
    end
  end

  def check_schedule(worker)
    @shifts.each do |shift|
      shift.worker_schedule(worker) if worker.total_scheduled_hours <= 40
    end
  end

  def add_workers
    loop do
      puts 'Enter the worker'
      worker = Worker.new(@workers.length)
      @workers << worker
      check_schedule(worker)
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
    shift = @shifts.find { |shift| shift.shift_id == shift_id }
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
      puts 'Enter 5 for find specific shift for its schedule.'
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
