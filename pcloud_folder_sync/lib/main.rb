require "pcloud_api"
require_relative "string_utils"
require_relative "downloader"


Pcloud::Client.configure(
  access_token: ENV["PCLOUD_ACCESS_TOKEN"],
  data_region: "EU"
)

target_pcloud_folder = Pcloud::Folder.find_by(path: Downloader::PCLOUD_FOLDER_PATH)
unless target_pcloud_folder
  raise "Could not find #{Downloader::PCLOUD_FOLDER_PATH} in pCloud".red
end

puts "============"
puts "💾 Downloading contents of '#{Downloader::PCLOUD_FOLDER_PATH}' to '#{Downloader::LOCAL_FOLDER_PATH}'".bold.cyan
puts "============"

Downloader.download_folder(target_pcloud_folder)
