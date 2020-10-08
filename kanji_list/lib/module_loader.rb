require 'yaml'
require 'logger'
require 'active_record'
require_relative '../db/connection'

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require(f) }

$logger = Logger.new('tmp/log.txt')
