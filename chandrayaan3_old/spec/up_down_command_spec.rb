# frozen_string_literal: true

require './main'

RSpec.describe UpDownCommand do
  let(:receiver) { LunarCommandReceiver.new }

  context 'when executing UpDownCommand' do
    it 'updates the current direction to the provided direction' do
      initial_direction = receiver.current_direction
      up_command = UpDownCommand.new(receiver, 'u')
      down_command = UpDownCommand.new(receiver, 'd')

      up_command.execute
      expect(receiver.current_direction).to eq('U')

      down_command.execute
      expect(receiver.current_direction).to eq('D')
    end
  end
end
