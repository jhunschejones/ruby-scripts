require_relative './module_loader'

# Always load state from S3 when starting
Rake::Task["db:download_from_s3"].invoke

puts "=======  Welcome to Kanji List!  =======".cyan

begin
  CLI.new.run
rescue CLI::ManualInterrupt
  # Always backup to S3 when quitting
  Rake::Task["db:upload_to_s3"].invoke
end
