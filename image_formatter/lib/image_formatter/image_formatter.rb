class ImageFormatter
  TARGET_HEIGHT_PX = 480
  TARGET_FILESIZE_KB = 50
  PROCESSED_IMAGE_SUFFIX = "_tinyified".freeze
  SUPPORTED_EXTENSIONS = [".jpeg", ".jpg", ".png"].freeze

  attr_reader :filename, :event

  def initialize(filename, event)
    @filename = filename
    @event = event
  end

  def process_event
    image_file = File.open(filename, 'rb')
    filesize_kb = (image_file.size.to_f / 1000).to_i
    height_px = ImageSize.new(image_file).height

    if filesize_kb > TARGET_FILESIZE_KB || height_px > TARGET_HEIGHT_PX
      log("\e[33m====== Tinyifying #{filename} ======\033[0m")

      Tinify.from_file(filename)
            .resize(method: "scale", height: TARGET_HEIGHT_PX)
            .to_file(output_file_name)

      FileUtils.mv(filename, BACKUP_FILES_PATH)

      puts "\e[32m====== Generated #{output_file_name} ======\033[0m"
    else
      puts "Skipping #{event} event for #{filename}: filesize is already small enough"
    end
  end

  def should_process_event?
    event == :created && !filename.include?(PROCESSED_IMAGE_SUFFIX) && SUPPORTED_EXTENSIONS.include?(File.extname(filename))
  end

  private

  def output_file_name
    directory_path = File.dirname(filename)
    base_filename = File.basename(filename, File.extname(filename))
    extension = File.extname(filename)

    "#{directory_path}/#{base_filename}#{PROCESSED_IMAGE_SUFFIX}#{extension}"
  end
end
