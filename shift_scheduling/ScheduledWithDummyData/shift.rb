# frozen_string_literal: true

# Shift have all possible shift for day
class Shift
  include GetDetail
  include GetAvailability
  attr_accessor :shift_id, :name, :start_time, :end_time, :wqwp, :shift_schedules

  def initialize(shift_id)
    @shift_id = shift_id
    # add_shift_name
    # shift_timings
    # position and their quantity

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
    WorkerAvailability::DAYS.each do |key, day|
      puts "==================Schedules for #{day} =========="
      shift_schedules = find_schedules(key)
      shift_schedules.each(&:show_detail) unless shift_schedules.empty?
    end
    puts '==================END Schedules =========='
  end

  def display
    puts "ShiftId:\t\t\t #{@shift_id}"
    puts "Name:\t\t\t #{@name}"
    puts "ShiftID\t\tWorker id and name\t\tWorker Position\tSchedule status"
  end

  def add_shift_name
    puts 'enter the shift name'
    @name = insert_detail
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

    return false unless all_vacant_schedules.length.positive?

    main_comman_range = range & work_availibilty.range

    return false unless !main_comman_range.nil? && main_comman_range.max != main_comman_range.min

    is_valid, comman_range, shift_schedule = work_availibilty.check_shift_hours(main_comman_range,
                                                                                previous_work_availibilty, all_vacant_schedules)

    return false unless is_valid

    return false if shift_schedule == ''

    return false unless !comman_range.nil? && comman_range.max != comman_range.min

    work_hours = comman_range.max - comman_range.min

    return false unless (worker.total_scheduled_hours + work_hours) <= 40

    work_availibilty.assign_shift_hours(comman_range)
    shift_schedule.assing_worker(worker.full_name, comman_range)
    worker.total_scheduled_hours = worker.total_scheduled_hours + (comman_range.max - comman_range.min)
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
