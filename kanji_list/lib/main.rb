require_relative './module_loader'

db_file_name = YAML::load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])["database"]

# Always load state from pcloud when starting

# ::File.open(db_file_name, "w") do |file|
#   file.binmode
#   print "Saving your file.."
#   HTTParty.get(download_url, stream_body: true) do |fragment|
#     file.write(fragment)
#     print "."
#   end
#   puts "."
# end

puts "=======  Welcome to Kanji List!  =======".cyan

kanji_list_dump_pcloud_file_id = ENV["KANJI_LIST_DUMP_PCLOUD_FILE_ID"].to_i
kanji_db_pcloud_file_id = ENV["KANJI_DB_PCLOUD_FILE_ID"].to_i
kanji_list_pcloud_folder_id = ENV["KANJI_LIST_PCLOUD_FOLDER_ID"].to_i

begin
  CLI.new.run
rescue CLI::ManualInterrupt
  # Always backup when quitting
  Rake::Task["db:dump_to_yaml"].invoke

  Pcloud::File.upload(
    folder_id: kanji_list_pcloud_folder_id,
    filename: KANJI_YAML_DUMP_PATH.split("/").last,
    file: File.open("./#{KANJI_YAML_DUMP_PATH}"),
    overwrite: true
  )

  Pcloud::File.upload(
    folder_id: kanji_list_pcloud_folder_id,
    filename: db_file_name,
    file: File.open("./#{db_file_name}"),
    overwrite: true
  )
end
