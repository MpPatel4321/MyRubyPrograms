# frozen_string_literal: true

# shifts chedule
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
    if %w[partially_scheduled scheduled].include?(@status)
      @scheduled_hours.each_value do |range|
        @vacant_hours = @vacant_hours.map { |z| z - range }.flatten
      end
    end
    @vacant_hours
  end

  def show_detail
    if @status != 'vacant'
      workers = @scheduled_hours.map do |k, value|
        "#{k} :- #{value}"
      end.join(',')
      puts "#{@shift}\t\t#{workers}\t\t#{@position}\t\t#{@status}"
    else
      puts "#{@shift}\t\tNo worker scheduled\t\t#{@position}\t\t#{@status}"
    end
  end
end
