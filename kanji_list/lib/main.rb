require_relative './module_loader'

Rake::Task["db:download_from_s3"].invoke

puts "=======  Welcome to Kanji List!  =======".cyan
CLI.new.run
