# frozen_string_literal: true

# Restaurant
class Restaurant
  include GetDetail
  attr_accessor :name, :shifts, :workers

  def initialize
    @workers = []
    @shifts = []
  end

  def run
    puts 'Enter Restaurant Name'
    @name = insert_detail
    puts "======================Welcome #{@name}======================="
    Position.instance
    add_shifts
    add_worker_and_schedule
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
    WorkerAvailability::DAYS.each_key do |day|
      @shifts.each do |shift|
        shift.worker_schedule(worker, day) if worker.total_scheduled_hours < 40
      end
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
    worker = @workers.find { |wr| wr.worker_id.downcase == worker_id.downcase }
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
    shift = @shifts.find { |sft| sft.shift_id == shift_id }
    if shift.nil?
      puts 'No shift is found'
    else
      shift.show_detail
    end
  end

  def add_worker_and_schedule
    loop do
      display_options
      case gets.chomp.to_i
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

  def display_options
    puts '==================================================='
    puts 'Enter 1 for add worker.'
    puts 'Enter 2 for show all workers.'
    puts 'Enter 3 for find worker and their availbilty.'
    puts 'Enter 4 for show all shifts'
    puts 'Enter 5 for find specific shift for its schedule.'
    puts 'Enter 6 for Exit.'
    puts '==================================================='
  end
end
