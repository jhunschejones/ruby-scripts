require_relative './module_loader.rb'

WATCH_DIRECTORY = File.expand_path("~/Downloads/Card\ Images").freeze
WATCH_PATH = "#{WATCH_DIRECTORY}/*".freeze
BACKUP_FILES_PATH = File.expand_path("~/Downloads/Card\ Images/_Pre\ Tinyification\ Images").freeze

# == Locate or create required state on startup ==
puts "Image Formatter is running for '#{WATCH_PATH}'".cyan
FileUtils.mkdir_p(BACKUP_FILES_PATH) unless Dir.exist?(BACKUP_FILES_PATH)

# == Make sure Tinyfy config is working on startup ==
Tinify.key = ENV["TINIFY_API_KEY"]
Tinify.validate!
log("#{Tinify.compression_count} compressions this month")

# == Run file watcher loop ==
Filewatcher.new(WATCH_PATH, exclude: BACKUP_FILES_PATH, interval: 0).watch do |watcher_event|
  filename, event = watcher_event.to_a.first
  image_formatter = ImageFormatter.new(filename, event)
  if image_formatter.should_process_event?
    Thread.new { image_formatter.process_event }
  else
    puts "Skipping #{event} event for #{filename}"
  end
end
