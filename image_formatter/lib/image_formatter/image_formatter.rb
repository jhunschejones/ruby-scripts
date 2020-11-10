class ImageFormatter
  TARGET_HEIGHT_PX = 480
  TARGET_FILESIZE_KB = 50
  TINYIFIED_IMAGE_SUFFIX = "_tinyified".freeze
  TEMP_FILE_EXTENSION = ".tinyifying".freeze
  SUPPORTED_EXTENSIONS = [".jpeg", ".jpg", ".png"].freeze
  MINI_MAGICK_TEMP_SUFFIX = "~".freeze
  RESIZED_SUFFIX = "_resized".freeze

  attr_reader :filename, :event

  def initialize(filename, event)
    @filename = filename
    @event = event
  end

  def process_event
    if mini_magick_image.height > TARGET_HEIGHT_PX
      log("====== Resizing #{filename} ======".yellow)    
      backup_origional_file
      resize_image
      return true
    end

    if image_filesize_kb > TARGET_FILESIZE_KB
      begin
        log("====== Tinyifying #{filename} ======".yellow)
        create_temp_file
        tinyify_image
        log("====== Generated #{tinyified_file_name} ======".green)
        backup_origional_file
      rescue => e
        log("Unable to tinyify #{filename}: #{e.message}".red)
      end

      clean_up_temp_file
      return true
    end

    puts "Skipping #{event} event for #{filename}: filesize is already small enough"
  end

  def should_process_event?
    event == :created &&
      !filename.include?(TINYIFIED_IMAGE_SUFFIX) &&
      !filename.include?(TEMP_FILE_EXTENSION) &&
      filename[-1] != MINI_MAGICK_TEMP_SUFFIX &&
      SUPPORTED_EXTENSIONS.include?(File.extname(filename)) 
  end

  private

  def mini_magick_image
    @mini_magick_image ||= MiniMagick::Image.open(filename)
  end

  def resize_image
    # This image magic gemoetry syntax instructs the library to resize the image
    # if the height is greater than our max height, then save it to the same 
    # file name.
    mini_magick_image.geometry("x#{TARGET_HEIGHT_PX}>").write(resized_file_name)
  end

  def tinyify_image
    Tinify.from_file(filename).to_file(tinyified_file_name)
  end

  def image_filesize_kb
    (mini_magick_image.size.to_f / 1000).to_i
  end

  def temp_file_name
    directory_path = File.dirname(filename)
    base_filename = File.basename(filename, File.extname(filename))

    "#{directory_path}/#{base_filename}#{TEMP_FILE_EXTENSION}"
  end

  def resized_file_name
    directory_path = File.dirname(filename)
    base_filename = File.basename(filename, File.extname(filename))
    extension = File.extname(filename)

    "#{directory_path}/#{base_filename}#{RESIZED_SUFFIX}#{extension}"
  end

  def tinyified_file_name
    directory_path = File.dirname(filename)
    base_filename = File.basename(filename, File.extname(filename))
    extension = File.extname(filename)

    "#{directory_path}/#{base_filename}#{TINYIFIED_IMAGE_SUFFIX}#{extension}"
  end

  def create_temp_file
    File.new(temp_file_name, "w")
  end

  def clean_up_temp_file
    FileUtils.rm(temp_file_name)
  end

  def backup_origional_file
    if filename.include?(RESIZED_SUFFIX)
      # If the image has already been resized it is not an origional which
      # means we do not need to worry about backing it up.
      File.delete(filename)
    else 
      FileUtils.mv(filename, BACKUP_FILES_PATH)
    end
  end
end
