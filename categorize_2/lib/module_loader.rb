require "csv"
require "yaml"
require "ostruct"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == "categorize.rb"
end
