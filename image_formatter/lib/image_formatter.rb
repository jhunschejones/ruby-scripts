require_relative '../lib/module_loader'

TARGET_HEIGHT_PX = 480
TARGET_FILESIZE_KB = 50
PROCESSED_IMAGE_SUFFIX = "_tinyified".freeze
WATCH_DIRECTORY = File.expand_path("~/Downloads/Card\ Images").freeze
WATCH_PATH = "#{WATCH_DIRECTORY}/*".freeze
BACKUP_FILES_PATH = File.expand_path("~/Downloads/Card\ Images/_Pre\ Tinyification\ Images").freeze
SUPPORTED_EXTENSIONS = [".jpeg", ".jpg", ".png"].freeze

def output_file_name(filename)
  directory_path = File.dirname(filename)
  base_filename = File.basename(filename, File.extname(filename))
  extension = File.extname(filename)

  "#{directory_path}/#{base_filename}#{PROCESSED_IMAGE_SUFFIX}#{extension}"
end

def should_process_event?(filename, event)
  event == :created && !filename.include?(PROCESSED_IMAGE_SUFFIX) && SUPPORTED_EXTENSIONS.include?(File.extname(filename))
end

######

system("clear")
puts "\033[36mImage Formatter is running for '#{WATCH_PATH}'\033[0m"
raise "Can't find required paths" unless Dir.exist?(WATCH_DIRECTORY) && Dir.exist?(BACKUP_FILES_PATH)

Filewatcher.new(WATCH_PATH, exclude: BACKUP_FILES_PATH).watch do |watcher_event|
  filename, event = watcher_event.to_a.first

  if should_process_event?(filename, event)
    image_file = File.open(filename, 'rb')
    filesize_kb = (image_file.size.to_f / 1000).to_i
    height_px = ImageSize.new(image_file).height

    if filesize_kb > TARGET_FILESIZE_KB || height_px > TARGET_HEIGHT_PX
      puts "\e[33m====== Tinyifying #{filename} ======\033[0m"
      Tinify.key = ENV["TINIFY_API_KEY"]
      Tinify.validate!
      Tinify.from_file(filename)
            .resize(method: "scale", height: TARGET_HEIGHT_PX)
            .to_file(output_file_name(filename))

      FileUtils.mv(filename, BACKUP_FILES_PATH)

      puts "\e[32m====== Generated #{output_file_name(filename)} ======\033[0m"
      puts "#{Tinify.compression_count} compressions this month"
    else
      puts "Skipping #{event} event for #{filename}: filesize is already small enough"
    end
  else
    puts "Skipping #{event} event for #{filename}"
  end
end
