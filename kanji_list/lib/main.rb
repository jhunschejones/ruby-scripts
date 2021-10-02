require_relative './module_loader'

puts "=======  Welcome to Kanji List!  =======".cyan

begin
  CLI.new.run
rescue CLI::ManualInterrupt
  Rake::Task["db:upload_to_pcloud"].invoke unless ENV["SCRIPT_ENV"] == "test"
end
