require 'yaml'
require 'active_record'

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/app/models/*.rb").each{|f| require f}

connection_details = YAML::load(File.open('config/database.yml'))["development"]
ActiveRecord::Base.establish_connection(connection_details)

puts Kanji.count
