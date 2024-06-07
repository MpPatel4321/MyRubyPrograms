# frozen_string_literal: true

require 'byebug'
class Company
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
  # alias_method :&, :overlaps

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

  def get_detail
    name = ''
    loop do
      name = gets.chomp.to_s
      break unless name == ''
    end
    name
  end

  def get_available_from(availabilty)
    puts "Enter availbilty of #{availabilty} for example and between 0 - 24 in hrs)"
    gets.chomp.to_s.split('-').map(&:strip).map(&:to_i)
  end

  attr_accessor :shift, :shift_range, :day, :position, :scheduled_hours, :status, :rank, :vacant_hours, :shift_id,
                :name, :start_time, :end_time, :wqwp, :shift_schedules, :available_from, :till_available, :available, :consumed_hours, :remaining_hours, :shifts_hours, :worked_hours, :worker_id, :total_scheduled_hours, :availablities, :current_positions, :shifts, :workers

  def initialize_shif_schedule(day, shift, position, rank, shift_range)
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

  def initialize_shift(shift_id)
    @shift_id = shift_id
    add_shift_name
    shift_timings
    # position and their quantity
    @wqwp = {}

    @shift_schedules = []

    add_position_and_quantity
    # shift scheduling with worker availability
  end

  def initialize_dummy_shift(arg)
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

  def minimum_details_shift
    puts "#{@shift_id}\t\t#{@name}\t\t#{@start_time}\t\t#{@end_time}"
  end

  def show_detail_shift
    puts "ShiftId:\t\t\t #{@shift_id}"
    puts "Name:\t\t\t #{@name}"
    puts "ShiftID\t\tWorker id and name\t\tWorker Position\tSchedule status"
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

  def worker_schedule(worker, day)
    work_availibilty = worker.fetch_availablities(day)
    previous_work_availibilty = worker.fetch_availablities((day.ord - 1).chr) if day != '0'

    return false if worker.total_scheduled_hours >= 40 || !work_availibilty.can_available?(self)

    all_vacant_schedules = fetch_all_schedules(day, worker.current_positions)
    return unless all_vacant_schedules.length.positive?

    main_comman_range = range & work_availibilty.range
    is_valid, comman_range = work_availibilty.check_shift_hours(main_comman_range, previous_work_availibilty)
    return unless is_valid
    return unless !comman_range.nil? && comman_range.max != comman_range.min

    work_hours = comman_range.max - comman_range.min
    return unless (worker.total_scheduled_hours + work_hours) <= 40

    shift_schedule = all_vacant_schedules.first
    work_availibilty.assign_shift_hours(comman_range)
    work_availibilty.assign_shifts_hours(main_comman_range, previous_work_availibilty)
    shift_schedule.assing_worker(worker.full_name, comman_range)
    worker.total_scheduled_hours = worker.total_scheduled_hours + (comman_range.max - comman_range.min)
  end

  def fetch_all_schedules(day, positions)
    @shift_schedules.find_all do |shift_schedule|
      shift_schedule.day == day && shift_schedule.status == 'vacant' && positions.include?(shift_schedule.position)
    end
  end

  def find_schedules(day)
    @shift_schedules.find_all { |shift_schedule| shift_schedule.day == day }
  end

  def range
    @start_time..@end_time
  end

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
    @positions ||= %w[cook shipper] # add_positions
  end

  DAYS = {
    '0' => 'Sunday',
    '1' => 'Monday',
    '2' => 'Tuesday',
    '3' => 'Wednesday',
    '4' => 'Thursday',
    '5' => 'friday',
    '6' => 'Saturday'
  }.freeze

  def initialize_worker_availability(day, dummy = 0)
    @day = day
    if dummy.zero?
      @consumed_hours = 0
      @available = get_available
      @remaining_hours = 0

      if @available == 'Y' || @available == 'y'
        @available_from, @till_available = get_available_from('worker')
        @remaining_hours = @till_available - @available_from
        @vacant_hours = [range]
      end
      @shifts_hours = []
    end
    self
  end

  def dummy_data_worker_availability(available, start_t)
    @consumed_hours = 0
    @remaining_hours = 0
    @available = available # get_available
    if @available == 'Y' || @available == 'y'
      @available_from, @till_available = start_t # get_available_from("worker")
      @remaining_hours = @till_available - @available_from
      @vacant_hours = [range]
    end
    @shifts_hours = []
    self
  end

  def can_available?(shift)
    return false unless %w[Y y].include?(@available)

    comman_range = shift.range & range
    return false if comman_range.nil?

    true
  end

  def get_available
    puts "Press Y or y for available for #{DAYS[@day]}"
    available = gets.chomp.to_s
  end

  def display_worker_availability
    if %w[Y y].include?(@available)
      puts "#{DAYS[@day]}\t\t   #{@available_from}\t\t\t  #{@till_available}"
    else
      puts "#{DAYS[@day]}\t\t\t  Not Available"
    end
  end

  def assign_shift_hours(common_range)
    @remaining_hours -= (common_range.max - common_range.min)
    @consumed_hours += (common_range.max - common_range.min)
    available_time
  end

  def assign_shifts_hours(common_range, previous_work)
    if @shifts_hours.empty?
      if !previous_work.nil? && %w[Y y].include?(previous_work.available)
        last = previous_work.shifts_hours.last
        if ((24 + common_range.min) - last.max) < 10
          if last.max == 24 && common_range.min.zero?
            last_max = 10 - (last.max - last.min)
            common_range = (common_range.min..last_max)
          else
            common_range = (((last.max + 10) - 24)..common_range.max)
          end
        end
      end
      @shifts_hours << common_range
    elsif @shifts_hours.last.max == common_range.min
      if (common_range.max - @shifts_hours.last.min) <= 10
        @shifts_hours = [@shifts_hours.last.min..common_range.max]
      else
        last = (@shifts_hours.last.min + 10) > common_range.max ? common_range.max : (@shifts_hours.last.min + 10)
        @shifts_hours = [@shifts_hours.last.min..last]
      end
    elsif (common_range.min - @shifts_hours.last.max) > 10
      @shifts_hours << common_range
    elsif @shifts_hours.last.max != common_range.min && (common_range.min - @shifts_hours.last.max) < 10
      last = @shifts_hours.last.max + 10
      common_range = (last..common_range.max)
      @shifts_hours << common_range
    end
  end

  def check_shift_hours(common_range, previous_work)
    if @shifts_hours.empty?
      if !previous_work.nil? && %w[Y y].include?(previous_work.available) && !previous_work.shifts_hours.empty?
        last = previous_work.shifts_hours.last
        if ((24 + common_range.min) - last.max) < 10
          if last.max == 24 && common_range.min.zero?
            last_max = 10 - (last.max - last.min)
            common_range = (common_range.min..last_max)
          else
            common_range = (((last.max + 10) - 24)..common_range.max)
          end
        end
      end
      # @shifts_hours << common_range
      [true, common_range]
    elsif (@shifts_hours.last.max - @shifts_hours.last.min) >= 10
      [false, common_range]
    elsif @shifts_hours.last.max == common_range.min
      return [true, common_range] if (common_range.max - @shifts_hours.last.min) <= 10

      last = (@shifts_hours.last.min + 10) > common_range.max ? common_range.max : (@shifts_hours.last.min + 10)
      common_range = (common_range.min..last)

      [true, common_range]
    elsif (common_range.min - @shifts_hours.last.max) > 10
      [true, common_range]
    elsif @shifts_hours.last.max != common_range.min && (common_range.min - @shifts_hours.last.max) < 10
      last = @shifts_hours.last.max + 10
      common_range = (last..common_range.max)
      [true, common_range]
    else
      [false, common_range]
    end
  end

  def available_time
    @shifts_hours.each do |range|
      @vacant_hours = @vacant_hours.map { |z| z - range }.flatten
    end
    @vacant_hours
  end

  def range
    (@available_from..@till_available)
  end

  def initialize_worker(worker_id, dummy = 0)
    @worker_id = "RSI#{worker_id}"
    @total_scheduled_hours = 0
    @name = ''
    @current_positions = []
    @availablities = []
    start if dummy.zero?
  end

  def initialize_dummy_worker(arg)
    @name = arg[:name]
    @current_positions = arg[:current_positions]
    arg[:availablities].each do |available|
      @availablities << WorkerAvailability.new(available[:day], 1).dummy_data(available[:available],
                                                                              available[:start_t])
    end
  end

  def fetch_availablities_worker(day)
    availablities.detect { |available| available.day == day }
  end

  def full_name_worker
    "#{@worker_id}  #{@name}"
  end

  def start_worker
    add_worker_details
    add_current_positions
    add_availabilities
  end

  def add_worker_details
    puts 'Enter worker name'
    @name = get_detail
  end

  def add_current_positions_worker
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

  def add_availabilities_worker
    puts 'Enter availabilities for weeks'
    WorkerAvailability::DAYS.each do |k, _v|
      @availablities << WorkerAvailability.new(k)
    end
  end

  def minimum_details_worker
    puts "#{@worker_id}\t\t#{@name}\t\t#{@current_positions.join(',')} \t\t #{@total_scheduled_hours}"
  end

  def show_detail_worker
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

  def initialize_restuarent
    $workers = Hash['workers_hahs' => []]
    $shifts = Hash['shifts_hash' => []]
  end

  def run
    puts 'Enter Restuarent Name'
    @name = 'Sayaji Indore' # get_detail
    puts "======================Welcome #{@name}======================="
    # instance_of?
    add_shifts
    # $workers = Hash["workers_hash" => []]
    # dummy_shifts
    add_worker_and_schedule
  end

  def dummy_shifts
    @shifts << Shift.new(@shifts.length).initialize_dummy(['night', [0, 8], { 'cook' => 1, 'shipper' => 1 }])
    @shifts << Shift.new(@shifts.length).initialize_dummy(['morning', [8, 16], { 'cook' => 2, 'shipper' => 1 }])
    @shifts << Shift.new(@shifts.length).initialize_dummy(['evening', [16, 24], { 'cook' => 2, 'shipper' => 1 }])
    worker = Worker.new($workers['workers_hash'].length, 1)
    worker.initialize_dummy({ name: 'user1', current_positions: ['cook'], availablities: [
                              { day: '0', available: 'Y', start_t: [4, 20] },
                              { day: '1', available: 'Y', start_t: [1, 23] },
                              { day: '2', available: 'Y', start_t: [16, 24] },
                              { day: '3', available: 'Y', start_t: [0, 22] },
                              { day: '4', available: 'n', start_t: [5, 14] },
                              { day: '5', available: 'n', start_t: [9, 15] },
                              { day: '6', available: 'n', start_t: [9, 15] }
                            ] })
    @workers << worker.to_h
    check_schedule(worker)

    worker = Worker.new($workers['workers'].length, 1)
    worker.initialize_dummy({ name: 'user2', current_positions: %w[cook shipper], availablities: [
                              { day: '0', available: 'Y', start_t: [5, 21] },
                              { day: '1', available: 'Y', start_t: [9, 18] },
                              { day: '2', available: 'Y', start_t: [9, 15] },
                              { day: '3', available: 'n', start_t: [9, 18] },
                              { day: '4', available: 'n', start_t: [9, 15] },
                              { day: '5', available: 'n', start_t: [9, 15] },
                              { day: '6', available: 'n', start_t: [9, 15] }
                            ] })
    @workers << worker.to_h
    check_schedule(worker)
  end

  def add_shifts
    loop do
      puts 'how many shifts do you want in a day'
      shift = gets.chomp.to_i
      # byebug
      next unless shift != 0 && shift < 12

      shift.times do
        $shifts['shifts_hash'] << ($shifts['shifts_hash'].length)
      end
      break
    end
  end

  def check_schedule(worker)
    WorkerAvailability::DAYS.each_key do |day|
      $shifts['shifts_hash'] do |shift|
        shift.worker_schedule(worker, day) if worker.total_scheduled_hours < 40
      end
    end
  end

  def add_workers
    loop do
      puts 'Enter the worker'
      worker = Worker.new($workers['workers_hash'].length)
      $workers['workers_hash'] << worker
      byebug
      check_schedule(worker)
      puts 'Enter Y to continue to add worker'
      break unless ['Y'].include?(gets.chomp.to_s)
    end
  end

  def show_all_workers
    if	$workers['workers_hash'].empty?
      puts 'No workers are available.'
    else
      puts "workerId\t\tName\t\tPositions"
      $workers['workers_hash'].each(&:minimum_details)
    end
  end

  def find_worker
    puts 'Enter worker id'
    worker_id = gets.chomp.strip
    worker = $workers['workers_hash'].find { |worker| worker.worker_id.downcase == worker_id.downcase }
    if worker.nil?
      puts 'No worker is found'
    else
      worker.show_detail
    end
  end

  def show_all_shifts
    if $shifts['shifts_hash'].empty?
      puts 'No shifts are available for this week.'
    else
      puts "shiftId\t\tName\t\tstart time\t end time"
      $shifts['shifts_hash'].each(&:minimum_details)
    end
  end

  def find_shift
    puts 'Enter shift id'
    shift_id = gets.chomp.strip.to_i
    shift = $shifts['shifts_hash'].find { |shift| shift.shift_id == shift_id }
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

company = Company.new
company.run
