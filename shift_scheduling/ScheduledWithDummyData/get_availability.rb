# frozen_string_literal: true

# GetAvailabilit
module GetAvailability
  def get_available_from(availabilty)
    puts "Enter availbilty of #{availabilty} between 0-24 in hrs"
    value = gets.chomp.to_s
    if value.include?('-')
      x, y = value.split('-').map(&:strip).map(&:to_i)
      if (x >= 0 && x < 24) && (y >= 0 && y < 24)
        [x, y]
      else
        puts 'Wrong information entered.'
        get_available_from(availabilty)
      end
    else
      puts 'Wrong information entered.'
      get_available_from(availabilty)
    end
  end
end
