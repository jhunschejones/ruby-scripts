module FileName
  RESIZED_SUFFIX = "_resized".freeze
  MINI_MAGICK_TEMP_SUFFIX = "~".freeze
  TEMP_FILE_EXTENSION = ".tinyifying".freeze
  TINYIFIED_IMAGE_SUFFIX = "_tinyified".freeze

  protected

  def temp_file_name
    "#{directory_path}/#{base_filename}#{TEMP_FILE_EXTENSION}"
  end

  def resized_file_name
    "#{directory_path}/#{base_filename}#{RESIZED_SUFFIX}#{extension}"
  end

  def tinyified_file_name
    "#{directory_path}/#{base_filename}#{TINYIFIED_IMAGE_SUFFIX}#{extension}"
  end

  def backup_file_name
    "#{BACKUP_FILES_PATH}/#{base_filename}#{extension}"
  end

  def directory_path
    File.dirname(image.filename)
  end

  def base_filename
    File.basename(image.filename, File.extname(image.filename))
  end

  def extension
    File.extname(image.filename)
  end
end
