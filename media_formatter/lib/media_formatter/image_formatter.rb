class ImageFormatter
  include ImageFileName

  TARGET_HEIGHT_PX = 480
  TARGET_FILESIZE_KB = 50
  SUPPORTED_EXTENSIONS = [".jpeg", ".jpg", ".png"].freeze

  attr_reader :event, :image

  def initialize(filename, event)
    @event = event
    @image = Image.new(filename)
  end

  def process_event
    if image.height > TARGET_HEIGHT_PX
      log("====== Resizing #{image.filename} ======".yellow)
      backup_origional_image
      resize_image
      return true
    end

    if image.filesize_kb > TARGET_FILESIZE_KB
      begin
        log("====== Tinyifying #{image.filename} ======".green)
        create_temp_file
        backup_origional_image
      rescue => e
        log("Unable to tinyify #{image.filename}: #{e.message}".red)
      end

      clean_up_temp_file
      return true
    end

    puts "Skipping #{event} event for #{image.filename}: filesize is already small enough"
  end

  def should_process_event?
    event == :created &&
      !image.filename.include?(TINYIFIED_IMAGE_SUFFIX) &&
      !image.filename.include?(TEMP_FILE_EXTENSION) &&
      image.filename[-1] != MINI_MAGICK_TEMP_SUFFIX &&
      SUPPORTED_EXTENSIONS.include?(extension)
  end

  private

  def resize_image
    # This image magic gemoetry syntax instructs the library to resize the image
    # if the height is greater than our max height, then save it to the same
    # file name.
    image.mini_magick.geometry("x#{TARGET_HEIGHT_PX}>").write(safe_resized_file_name)
  end

  def tinyify_image
    processed_file_name = safe_tinyified_file_name
    if ENV["DRY_RUN"]
      puts "... Bleep bloop blap ...".magenta
    else
      Tinify.from_file(image.filename).to_file(processed_file_name)
    end
    processed_file_name
  end

  def create_temp_file
    File.new(temp_file_name, "w")
  end

  def clean_up_temp_file
    FileUtils.rm(temp_file_name)
  end

  def backup_origional_image
    if image_already_resized?
      # If the image has already been resized it is not an origional which
      # means we do not need to worry about backing it up.
      File.delete(image.filename)
    else
      File.rename(image.filename, safe_backup_file_name)
    end
  end

  def image_already_resized?
    image.filename.include?(RESIZED_SUFFIX)
  end
end
