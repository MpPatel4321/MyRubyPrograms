# frozen_string_literal: true

# Concrete Command for Left/Right movement
class LeftRightCommand < Command
  def initialize(receiver, direction)
    super()
    @receiver = receiver
    @direction = direction
  end

  def execute
    @receiver.left_right(@direction)
  end
end
