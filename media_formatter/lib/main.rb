require_relative './module_loader.rb'

IMAGE_WATCH_DIRECTORY = File.expand_path("~/Downloads/Card\ Images").freeze
IMAGE_WATCH_PATH = "#{IMAGE_WATCH_DIRECTORY}/*".freeze
AUDIO_WATCH_DIRECTORY = File.expand_path("~/Downloads/Card\ Audio").freeze
AUDIO_WATCH_PATH = "#{AUDIO_WATCH_DIRECTORY}/*".freeze
BACKUP_IMAGE_FILES_PATH = File.expand_path("~/Downloads/Card\ Images/_Pre\ Tinyification\ Images").freeze

# == Locate or create required state on startup ==
puts "Image Formatter is running for '#{IMAGE_WATCH_PATH}'".cyan
FileUtils.mkdir_p(BACKUP_IMAGE_FILES_PATH) unless Dir.exist?(BACKUP_IMAGE_FILES_PATH)
FileUtils.mkdir_p(AUDIO_WATCH_DIRECTORY) unless Dir.exist?(AUDIO_WATCH_DIRECTORY)

# == Make sure Tinyfy config is working on startup ==
Tinify.key = ENV["TINIFY_API_KEY"]
Tinify.validate!
log("#{Tinify.compression_count} compressions this month")

# == Run file watcher loop ==
Filewatcher.new([IMAGE_WATCH_PATH, AUDIO_WATCH_PATH], exclude: BACKUP_IMAGE_FILES_PATH, interval: 0).watch do |watcher_event|
  filename, event = watcher_event.to_a.first
  image_formatter = ImageFormatter.new(filename, event)
  audio_processor = AudioProcessor.new(filename, event)
  if image_formatter.should_process_event?
    Thread.new { image_formatter.process_event }
  elsif audio_processor.should_process_event?
    Thread.new { audio_processor.process_event }
  else
    puts "Skipping #{event} event for #{filename}"
  end
end
