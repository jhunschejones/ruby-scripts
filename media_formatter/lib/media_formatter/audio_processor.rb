class AudioProcessor
  SUPPORTED_EXTENSIONS = [".mp3", ".m4a"].freeze
  PROCESSED_SUFFIX = "_processed".freeze

  attr_reader :event, :filename

  def initialize(filename, event)
    @event = event
    @filename = filename
  end

  def process_event
    return File.rename(filename, cli_safe_file_name) unless filename == cli_safe_file_name
    raise "Unable to find audio file duration" if input_file_duration.empty?

    log("====== Processing #{filename} ======".magenta)
    if audio_is_too_short?
      %x[ffmpeg -y -hide_banner -loglevel panic -i '#{filename}' -af apad,atrim=0:3,loudnorm=I=-16:TP=-1.5,atrim=0:#{input_file_duration} -ar 44.1k '#{safe_processed_filename}']
    else
      %x[ffmpeg -y -hide_banner -loglevel panic -i '#{filename}' -af loudnorm=I=-16:TP=-1.5 -ar 44.1k '#{safe_processed_filename}']
    end
    File.delete(filename)
  rescue => e
    log("Unable to process #{filename}: #{e.message}".red)
  end

  def should_process_event?
    event == :created &&
      !filename.include?(PROCESSED_SUFFIX) &&
      SUPPORTED_EXTENSIONS.include?(File.extname(filename))
  end

  private

  def audio_is_too_short?
    input_file_duration.to_f < 3.0
  end

  def base_filename
    File.basename(filename, File.extname(filename))
  end

  def processed_filename
    "#{AUDIO_WATCH_DIRECTORY}/#{base_filename}#{PROCESSED_SUFFIX}.mp3"
  end

  def safe_processed_filename
    return processed_filename unless File.exist?(processed_filename)
    "#{AUDIO_WATCH_DIRECTORY}/#{base_filename}_#{SecureRandom.uuid}#{PROCESSED_SUFFIX}.mp3"
  end

  def cli_safe_file_name
    "#{AUDIO_WATCH_DIRECTORY}/#{base_filename.parameterize.underscore}#{File.extname(filename)}"
  end

  def input_file_duration
    @input_file_duration ||= %x[ffprobe -i '#{filename}' -show_entries format=duration -v quiet -of csv='p=0'].chomp
  end
end
