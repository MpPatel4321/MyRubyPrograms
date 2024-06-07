# frozen_string_literal: true

# Concrete Command for Up/Down movement
class Runner < Command
  def run(commands)
    lunar_command_receiver = LunarCommandReceiver.new
    command_invoker = CommandInvoker.new

    commands.each do |command|
      dynamic_object = class_name(command).new(lunar_command_receiver, command)
      command_invoker.add_command(dynamic_object)
    end

    command_invoker.execute_commands
    lunar_command_receiver.print_output
  end

  def class_name(command)
    case command
    when 'f', 'b' then ForwardBackwardCommand
    when 'l', 'r' then LeftRightCommand
    when 'u', 'd' then UpDownCommand
    else
      raise ArgumentError, "#{command} is an invalid command"
    end
  rescue StandardError => e
    puts e.to_s
    exit
  end
end
