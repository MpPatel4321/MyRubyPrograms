# frozen_string_literal: true

# GetDetail
module GetDetail
  def insert_detail
    name = ''
    loop do
      name = gets.chomp.to_s
      break unless name == ''
    end
    name
  end
end
