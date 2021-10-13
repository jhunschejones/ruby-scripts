module Inbox
  class Processor
    include Inbox::Filename

    SUPPORTED_INBOX_EVENTS = [:found_in_inbox, :created].freeze

    attr_reader :filename, :event

    def initialize(filename, event)
      @filename = filename
      @event = event
    end

    def should_process_event?
      File.dirname(filename) == INBOX_DIRECTORY &&
        SUPPORTED_INBOX_EVENTS.include?(event)
    end

    def process_event
      if Image::Processor::SUPPORTED_EXTENSIONS.include?(File.extname(filename))
        destination_filename =
          if File.exist?("#{IMAGE_WATCH_DIRECTORY}/#{File.basename(filename)}")
            "#{IMAGE_WATCH_DIRECTORY}/#{File.basename(filename)}_#{SecureRandom.uuid}#{File.extname(filename)}"
          else
            "#{IMAGE_WATCH_DIRECTORY}/#{File.basename(filename)}"
          end
        puts "Sorting image file from inbox: #{filename}".blue
        return FileUtils.mv(filename, destination_filename)
      end

      if Audio::Processor::SUPPORTED_EXTENSIONS.include?(File.extname(filename))
        destination_filename =
          if File.exist?("#{AUDIO_DEPOSIT_DIRECTORY}/#{File.basename(filename)}")
            "#{AUDIO_DEPOSIT_DIRECTORY}/#{File.basename(filename)}_#{SecureRandom.uuid}#{File.extname(filename)}"
          else
            "#{AUDIO_DEPOSIT_DIRECTORY}/#{File.basename(filename)}"
          end
        puts "Sorting audio file from inbox: #{filename}".blue
        return FileUtils.mv(filename, destination_filename)
      end

      puts "WARNING: unrecognized inbox file".red
    end
  end
end
