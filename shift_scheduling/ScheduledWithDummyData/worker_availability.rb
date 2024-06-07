# frozen_string_literal: true

# Woker Availability for multiple days
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
  attr_accessor :day, :available_from, :till_available, :available, :consumed_hours, :remaining_hours, :shifts_hours,
                :vacant_hours, :worked_hours

  def initialize(day, dummy = 0)
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

  def dummy_data(available, start_t)
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

  def assign_shift_hours(common_range)
    @shifts_hours << common_range
    @remaining_hours -= (common_range.max - common_range.min)
    @consumed_hours += (common_range.max - common_range.min)
    available_time
  end

  def check_shift_hours(common_range, previous_work, all_vacant_schedules)
    result = []
    is_valid = false
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
      is_valid = true
    elsif @shifts_hours.last.max == common_range.min
      unless (common_range.max - @shifts_hours.last.min) <= 10
        last = (@shifts_hours.last.min + 10) > common_range.max ? common_range.max : (@shifts_hours.last.min + 10)
        common_range = (common_range.min..last)
      end
      is_valid = true
    elsif (common_range.min - @shifts_hours.last.max) > 10
      is_valid = true
    elsif @shifts_hours.last.max != common_range.min && (common_range.min - @shifts_hours.last.max) < 10
      last = @shifts_hours.last.max + 10
      common_range = (last..common_range.max)
      is_valid = true
    end
    if is_valid
      result = [is_valid, find_max_hour_schedule_range(common_range, all_vacant_schedules)].flatten
    else
      result << is_valid
    end
    result.flatten
  end

  def find_max_hour_schedule_range(range, all_vacant_schedules)
    scheduled = ''
    max_time_range = 0
    comman_range = range
    all_vacant_schedules.each do |schedule|
      schedule.vacant_hours.each do |vacant_range|
        next unless !(vacant_range & range).nil? && ((vacant_range & range).difference > max_time_range)

        max_time_range = (vacant_range & range).difference
        scheduled = schedule
        comman_range = vacant_range & range
      end
    end
    [comman_range, scheduled]
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
end
