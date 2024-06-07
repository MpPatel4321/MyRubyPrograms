# frozen_string_literal: true

require './main'

RSpec.describe LeftRightCommand do
  let(:receiver) { LunarCommandReceiver.new }

  context 'when executing LeftRightCommand' do
    it 'updates the current direction based on the input' do
      initial_direction = receiver.current_direction
      left_command = LeftRightCommand.new(receiver, 'l')
      right_command = LeftRightCommand.new(receiver, 'r')

      left_command.execute
      expect(receiver.current_direction).not_to eq(initial_direction)

      right_command.execute
      expect(receiver.current_direction).to eq(initial_direction)
    end
  end
end

