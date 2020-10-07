require 'yaml'
require 'active_record'
require_relative './db/connection'

Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].each { |f| require(f) }
