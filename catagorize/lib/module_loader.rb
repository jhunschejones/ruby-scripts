require 'csv'
require 'yaml'
require 'ostruct'

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require(f) }
