connection_details = YAML::load(File.open("config/database.yml"))["development"]
ActiveRecord::Base.establish_connection(connection_details)
