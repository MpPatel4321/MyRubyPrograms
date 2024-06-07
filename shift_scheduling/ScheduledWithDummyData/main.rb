# frozen_string_literal: true

$LOAD_PATH << '.'
require 'byebug'
require 'range'
require 'data_store'
require 'get_detail'
require 'get_availability'
require 'position'
require 'shift_schedule'
require 'shift'
require 'worker_availability'
require 'worker'
require 'restaurant'

restaurant = Restaurant.new
restaurant.run
