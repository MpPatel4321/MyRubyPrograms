# frozen_string_literal: true

# Invoker
class CommandInvoker
  def initialize
    @commands = []
  end

  def add_command(command)
    @commands << command
  end

  def execute_commands
    @commands.each(&:execute)
  end
end
