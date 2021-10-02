require_relative './module_loader'

puts "=======  Welcome to Kanji List!  =======".cyan

begin
  CLI.new.run
rescue CLI::ManualInterrupt
  if ENV["SCRIPT_ENV"] != "test" && ENV["KANJI_LIST_PCLOUD_FOLDER_ID"]
    Rake::Task["db:upload_to_pcloud"].invoke
  end
end
