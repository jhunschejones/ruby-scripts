require "pcloud_api"
require_relative "string_utils"
require_relative "downloader"


Pcloud::Client.configure(access_token: ENV["PCLOUD_ACCESS_TOKEN"], data_region: "EU")
target_pcloud_folder = Pcloud::Folder.find_by(path: Downloader::PCLOUD_FOLDER_PATH, recursive: true)
raise "Could not find #{Downloader::PCLOUD_FOLDER_PATH} in pCloud".red unless target_pcloud_folder

puts "============"
puts "💾 Downloading contents of '#{Downloader::PCLOUD_FOLDER_PATH}' to '#{Downloader::LOCAL_FOLDER_PATH}'".bold.cyan
puts "============"

downloader = Downloader.new
downloader.download_folder(pcloud_folder: target_pcloud_folder)

puts "\nProcessed #{downloader.files_processed_count} #{downloader.files_processed_count == 1 ? "file" : "files"} 🎉"
