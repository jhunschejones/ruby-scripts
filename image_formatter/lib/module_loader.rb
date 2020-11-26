require 'yaml'
require 'logger'
require 'fileutils'
require 'filewatcher'
require 'tinify'
require 'mini_magick'
require 'active_support'

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == 'main.rb'
end

$logger = Logger.new('tmp/log.txt')

def log(message)
  # Remove console color sequences in log messages
  $logger.debug(message.inspect.gsub(/"\\e\[\d{2}m|\\e\[0m"/, ''))
  puts message
end
