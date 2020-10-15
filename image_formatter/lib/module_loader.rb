require 'yaml'
require 'logger'
require 'fileutils'
require 'filewatcher'
require 'tinify'
require 'image_size'

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require(f) }

$logger = Logger.new('tmp/log.txt')
