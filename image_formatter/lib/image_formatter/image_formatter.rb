class ImageFormatter
  include FileName

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
        log("====== Tinyifying #{image.filename} ======".yellow)
        create_temp_file
        tinyify_image
        log("====== Generated #{tinyified_file_name} ======".green)
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
    image.mini_magick.geometry("x#{TARGET_HEIGHT_PX}>").write(resized_file_name)
  end

  def tinyify_image
    return puts "... Bleep bloop blap ...".magenta if ENV["DRY_RUN"]
    Tinify.from_file(image.filename).to_file(tinyified_file_name)
  end

  def create_temp_file
    File.new(temp_file_name, "w")
  end

  def clean_up_temp_file
    FileUtils.rm(temp_file_name)
  end

  def backup_origional_image
    if image_already_resized? || backup_image_already_exists?
      # If the image has already been resized it is not an origional which
      # means we do not need to worry about backing it up.
      File.delete(image.filename)
    else
      FileUtils.mv(image.filename, BACKUP_FILES_PATH)
    end
  end

  def image_already_resized?
    image.filename.include?(RESIZED_SUFFIX)
  end

  def backup_image_already_exists?
    File.exist?(backup_file_name)
  end
end
