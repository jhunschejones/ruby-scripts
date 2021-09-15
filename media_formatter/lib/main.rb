require_relative './module_loader.rb'

IMAGE_WATCH_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Images").freeze
IMAGE_WATCH_PATH = "#{IMAGE_WATCH_DIRECTORY}/*".freeze
BACKUP_IMAGE_FILES_PATH = File.expand_path("~/Downloads/Japanese/Card\ Images/_Pre\ Tinyification\ Images").freeze
AUDIO_WATCH_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Audio/To\ Process").freeze
AUDIO_WATCH_PATH = "#{AUDIO_WATCH_DIRECTORY}/*".freeze
AUDIO_DEPOSIT_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Audio/").freeze
BACKUP_AUDIO_FILES_PATH = File.expand_path("~/Downloads/Japanese/Card\ Audio/To\ Process/_RAW").freeze

# == Locate or create required state on startup ==
puts "Image Formatter is running for '#{IMAGE_WATCH_PATH}'".cyan
FileUtils.mkdir_p(BACKUP_IMAGE_FILES_PATH) unless Dir.exist?(BACKUP_IMAGE_FILES_PATH)
FileUtils.mkdir_p(BACKUP_AUDIO_FILES_PATH) unless Dir.exist?(BACKUP_AUDIO_FILES_PATH)

# == Make sure Tinyfy config is working on startup ==
Tinify.key = ENV["TINIFY_API_KEY"]
Tinify.validate!
log("#{Tinify.compression_count} image compressions this month")

# == Configure file watcher settings ==
filewatcher = Filewatcher.new(
  [IMAGE_WATCH_PATH, AUDIO_WATCH_PATH],
  exclude: [BACKUP_IMAGE_FILES_PATH, BACKUP_AUDIO_FILES_PATH],
  interval: 0
)

# == Setup and start a file processing queue ==
file_event_processor = FileEventProcessor.new.run

# == Run file watcher loop ==
filewatcher.watch do |watcher_event|
  file_event_processor.enqueue(
    watcher_event
      .to_a
      # Sometimes the watcher sees a list of events, sometimes just one.
      # This makes sure we're always passing a flat array of all events.
      .flat_map { |watcher_event| FileEvent.new(*watcher_event) }
  )
end
