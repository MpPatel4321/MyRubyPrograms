# frozen_string_literal: true

require 'RMagick'

img = Magick::Image.read(ARGV[0] || 'Flower_Hat.jpg').first
