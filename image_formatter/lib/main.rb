require_relative './module_loader.rb'

WATCH_DIRECTORY = File.expand_path("~/Downloads/Card\ Images").freeze
WATCH_PATH = "#{WATCH_DIRECTORY}/*".freeze
BACKUP_FILES_PATH = File.expand_path("~/Downloads/Card\ Images/_Pre\ Tinyification\ Images").freeze

# == Validate required state on startup ==
puts "\033[36mImage Formatter is running for '#{WATCH_PATH}'\033[0m"
raise "Can't find required paths" unless Dir.exist?(WATCH_DIRECTORY) && Dir.exist?(BACKUP_FILES_PATH)
Tinify.key = ENV["TINIFY_API_KEY"]
Tinify.validate!
log("#{Tinify.compression_count} compressions this month")

# == Run file watcher loop ==
Filewatcher.new(WATCH_PATH, exclude: BACKUP_FILES_PATH).watch do |watcher_event|
  filename, event = watcher_event.to_a.first
  image_formatter = ImageFormatter.new(filename, event)
  if image_formatter.should_process_event?
    image_formatter.process_event
  else
    puts "Skipping #{event} event for #{filename}"
  end
end
