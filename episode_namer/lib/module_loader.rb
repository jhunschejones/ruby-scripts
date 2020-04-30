Dir["#{File.dirname(__FILE__)}/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require(f) }
