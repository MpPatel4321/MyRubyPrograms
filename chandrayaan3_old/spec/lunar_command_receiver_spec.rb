# frozen_string_literal: true

require './main'

RSpec.describe LunarCommandReceiver do
  let(:receiver) { LunarCommandReceiver.new }

  context 'when executing commands' do
    it 'updates the position and direction correctly' do
      command_invoker = CommandInvoker.new
      commands = %w[f r u b l d]

      commands.each do |command|
        case command
        when 'f', 'b'
          command_invoker.add_command(ForwardBackwardCommand.new(receiver, command))
        when 'l', 'r'
          command_invoker.add_command(LeftRightCommand.new(receiver, command))
        when 'u', 'd'
          command_invoker.add_command(UpDownCommand.new(receiver, command))
        end
      end

      command_invoker.execute_commands

      expect(receiver.x).to eq(0)
      expect(receiver.y).to eq(1)
      expect(receiver.z).to eq(-1)
      expect(receiver.current_direction).to eq('D')
    end
  end
end
