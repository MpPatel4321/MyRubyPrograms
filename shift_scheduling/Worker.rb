# frozen_string_literal: true

class Worker
  def initialize(name)
    @name = name

    @avail   = {}
    @prefers = {}
  end

  attr_reader :name

  def can_work(day, times)
    @avail[day] = parse_times(times)

    @prefers[day] = if times =~ /\((?:prefers )?([^)]+)\s*\)/
                      parse_times(::Regexp.last_match(1))
                    else
                      Hour.new('12 AM')..Hour.new('11 PM')
                    end
  end

  def available?(day, hour)
    if @avail[day].nil?
      false
    else
      @avail[day].include?(hour)
    end
  end

  def prefers?(day, hour)
    return false unless available? day, hour

    if @prefers[day].nil?
      false
    else
      @prefers[day].include?(hour)
    end
  end

  def ==(other)
    @name == other.name
  end

  def to_s
    @name.to_s
  end

  private

  def parse_times(times)
    case times
    when /^\s*any\b/i
      Hour.new('12 AM')..Hour.new('11 PM')
    when /^\s*before (\d+ [AP]M)\b/i
      Hour.new('12 AM')..Hour.new(::Regexp.last_match(1))
    when /^\s*after (\d+ [AP]M)\b/i
      Hour.new(::Regexp.last_match(1))..Hour.new('11 PM')
    when /^\s*(\d+ [AP]M) to (\d+ [AP]M)\b/i
      Hour.new(::Regexp.last_match(1))..Hour.new(::Regexp.last_match(2))
    when /^\s*not available\b/i
      nil
    else
      raise 'Unexpected availability format.'
    end
  end
end

w = Worker.new('jj')
puts 'aaaaaaaaaaaaaaa'

# ----------------------------------------------------
#  %w{Mon Tue Wed Thu Fri Sat Sun}.each do |day|
#             puts "#{day}:"
#             schedule[day].each do |hour, worker|
#                 puts "  #{hour}:  #{worker}"
#             end
#         end
#     end
