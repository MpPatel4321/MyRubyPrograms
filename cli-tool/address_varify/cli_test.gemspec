# frozen_string_literal: true

require_relative "lib/cli_test/version"

Gem::Specification.new do |spec|
  spec.name          = 'cli_test'
  spec.version       = '0.1.0'
  spec.authors       = ['Shaan']
  spec.summary       = 'A brief description of your gem'
  spec.description   = 'A more detailed description of your gem'
  spec.email         = 'ror.shaan@gmail.com'
  spec.files         = Dir['lib/**/*.rb'] + ['bin/cli_test']
  spec.add_dependency 'geocoder'
end

