require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: greet.rb [options]"

  opts.on('-n', '--name NAME', 'Your name') do |name|
    options[:name] = name
  end
end.parse!

name = options[:name] || 'World'
puts "Hello, #{name}!"