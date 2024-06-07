# frozen_string_literal: true

# Positions
class Position
  def self.add_positions
    puts 'Enter all positions seprated with comma '
    position = gets.chomp.to_s.strip
    if position != ''
      position.split(',').map(&:strip).uniq
    else
      puts 'Positions should not be blank'
      add_positions
    end
  end

  def self.instance
    @instance ||= %w[cook shipper] # add_positions
  end
end
