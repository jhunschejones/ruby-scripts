require "fileutils"
require "httparty"
require "pcloud_api"

class Downloader
  LOCAL_FOLDER_PATH = ENV["LOCAL_FOLDER_PATH"]
  PCLOUD_FOLDER_PATH = ENV["PCLOUD_FOLDER_PATH"]

  attr_reader :files_processed_count

  def initialize
    @files_processed_count = 0
  end

  def download_file(pcloud_file:, path: PCLOUD_FOLDER_PATH)
    raise "`path` cannot be nil".red if path.nil?

    # Make a local directory if one doesn't exist yet
    subdirectory_path = "#{LOCAL_FOLDER_PATH}/#{path.gsub(PCLOUD_FOLDER_PATH, "")}".gsub("//", "/")
    unless Dir.exist?(subdirectory_path)
      puts "Creating local subdirectory #{subdirectory_path}...".green
      FileUtils.mkdir_p(subdirectory_path)
    end
    local_filepath = "#{subdirectory_path}/#{pcloud_file.name}".gsub("//", "/")

    # Keep track of how many files have been processed
    @files_processed_count = files_processed_count + 1

    # Local file already exists and is newer than the version in pCloud
    if ::File.exist?(local_filepath) && ::File.ctime(local_filepath) > pcloud_file.created_at
      puts "Already exists: #{pcloud_file.name}".gray
      return
    end

    ::File.open(local_filepath, "w") do |new_file|
      new_file.binmode
      puts "Downloading #{pcloud_file.name} from pCloud...".cyan
      HTTParty.get(pcloud_file.download_url, stream_body: true) do |fragment|
        new_file.write(fragment)
      end
    end
  end

  def download_folder(pcloud_folder:, previous_path: PCLOUD_FOLDER_PATH)
    # For sub-subdirectories `path` is `nil`. Passing `previous_path` along helps us build a directory
    # structure locally that more acurately matches what's in pCloud.
    path = pcloud_folder.path || "#{previous_path}/#{pcloud_folder.name}"
    pcloud_folder
      .contents
      .each do |item|
        next download_file(pcloud_file: item, path: path) if item.is_a?(Pcloud::File)
        next download_folder(pcloud_folder: item, previous_path: path) if item.is_a?(Pcloud::Folder)
        puts "Unrecognized pCloud item #{item}".red
      end
  end
end
