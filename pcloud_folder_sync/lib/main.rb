require "pcloud_api"

raise "Couldn't find '#{ENV["LOCAL_FOLDER_PATH"]}' directory" unless Dir.exist?(ENV["LOCAL_FOLDER_PATH"])

Pcloud::Client.configure(
  access_token: ENV["PCLOUD_ACCESS_TOKEN"],
  data_region: "EU"
)

Pcloud::Folder
  .find_by(path: ENV["PCLOUD_FOLDER_PATH"])
  .contents
  .filter { |item| item.is_a?(Pcloud::File) }
  .each do |pcloud_file|
    local_file = ENV["LOCAL_FOLDER_PATH"] + "/" + pcloud_file.name

    # Local file already exists and is newer than the version in pCloud
    next if ::File.exist?(local_file) && ::File.ctime(local_file) > pcloud_file.created_at

    ::File.open(local_file, "w") do |new_file|
      new_file.binmode
      puts "Downloading #{pcloud_file.name} from pCloud..."
      HTTParty.get(pcloud_file.download_url, stream_body: true) do |fragment|
        new_file.write(fragment)
      end
    end
  end
