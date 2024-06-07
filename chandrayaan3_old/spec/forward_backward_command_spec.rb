# frozen_string_literal: true

require './main'

RSpec.describe ForwardBackwardCommand do
  let(:receiver) { LunarCommandReceiver.new }

  context 'when executing ForwardBackwardCommand' do
    it 'increases or decreases the y-coordinate based on the direction' do
      initial_y = receiver.y
      forward_command = ForwardBackwardCommand.new(receiver, 'f')
      backward_command = ForwardBackwardCommand.new(receiver, 'b')

      forward_command.execute
      expect(receiver.y).to eq(initial_y + 1)

      backward_command.execute
      expect(receiver.y).to eq(initial_y)
    end
  end
end
