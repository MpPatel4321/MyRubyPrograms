# frozen_string_literal: true

class Worker
  include GetDetail
  attr_accessor :worker_id, :total_scheduled_hours, :availablities, :current_positions

  def initialize(worker_id, dummy = 0)
    @worker_id = "RSI#{worker_id}"
    @total_scheduled_hours = 0
    @name = ''
    @current_positions = []
    @availablities = []
    start if dummy.zero?
  end

  def initialize_dummy(arg)
    @name = arg[:name]
    @current_positions = arg[:current_positions]
    arg[:availablities].each do |available|
      @availablities << WorkerAvailability.new(available[:day], 1).dummy_data(available[:available],
                                                                              available[:start_t])
    end
  end

  def fetch_availablities(day)
    availablities.detect { |available| available.day == day }
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
    @name = insert_detail
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
