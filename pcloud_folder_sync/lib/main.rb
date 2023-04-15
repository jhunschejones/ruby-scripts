require "pcloud_api"

Pcloud::Client.configure(
  access_token: ENV["PCLOUD_ACCESS_TOKEN"],
  data_region: "EU"
)

folder = Pcloud::Folder.find_by(path: ENV["PCLOUD_FOLDER_PATH"])
puts "Found #{folder.contents.size} items in your folder"
