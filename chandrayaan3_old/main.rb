# frozen_string_literal: true

$LOAD_PATH << '.'
require 'byebug'
require 'command'
require 'runner'
require 'forward_backward_command'
require 'left_right_command'
require 'up_down_command'
require 'command_invoker'
require 'lunar_command_receiver'

commands = %w[f r u b l]
# puts "Please Enter commands saperated by ','"
# commands = gets.chomp.to_s.split(',').map(&:strip)
runner = Runner.new
runner.run(commands)
