# frozen_string_literal: true

# Concrete Command for Up/Down movement
class UpDownCommand < Command
  def initialize(receiver, direction)
    super()
    @receiver = receiver
    @direction = direction
  end

  def execute
    @receiver.up_down(@direction)
  end
end
