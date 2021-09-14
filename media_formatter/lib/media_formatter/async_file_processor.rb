class AsyncFileProcessor
  FILE_PROCESSING_INTERVAL_SECONDS = 0.5.freeze

  def initialize
    @files_to_process = []
  end

  def enqueue(file_to_process)
    @files_to_process << file_to_process
  end

  def run
    Thread.new do
      loop do
        process(*@files_to_process.shift) unless @files_to_process.size.zero?
        sleep FILE_PROCESSING_INTERVAL_SECONDS
      end
    end
    self # returning self to make this method chain-able
  end

  private

  def process(filename, event)
    image_formatter = ImageFormatter.new(filename, event)
    audio_processor = AudioProcessor.new(filename, event)
    return image_formatter.process_event if image_formatter.should_process_event?
    return audio_processor.process_event if audio_processor.should_process_event?
    puts "Skipping #{event} event for #{filename}".gray
  end
end
