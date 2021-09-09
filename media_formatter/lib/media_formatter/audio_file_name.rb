module AudioFileName
  SPECIAL_CHARACTERS = /[:'"\/\\.$,?!]/.freeze

  protected

  def processed_filename
    "#{AUDIO_DEPOSIT_DIRECTORY}/#{base_filename}#{processed_suffix}.mp3"
  end

  def safe_processed_filename
    return processed_filename unless File.exist?(processed_filename)
    "#{AUDIO_DEPOSIT_DIRECTORY}/#{base_filename}_#{SecureRandom.uuid}#{processed_suffix}.mp3"
  end

  def backup_file_name
    "#{BACKUP_AUDIO_FILES_PATH}/#{base_filename}#{file_extension}"
  end

  def safe_backup_file_name
    return backup_file_name unless File.exist?(backup_file_name)
    "#{BACKUP_AUDIO_FILES_PATH}/#{base_filename}_#{SecureRandom.uuid}#{file_extension}"
  end

  def cli_safe_file_name
    # Just remove special characters that could cause problems
    "#{AUDIO_WATCH_DIRECTORY}/#{base_filename.gsub(SPECIAL_CHARACTERS, '').strip}#{file_extension}"
    # Smash the name into a conservative string, only works with english characters
    # "#{AUDIO_WATCH_DIRECTORY}/#{base_filename.parameterize.underscore}#{file_extension}"
  end

  def processed_suffix
    "_processed_#{::AudioProcessor::PEAK_LEVEL}#{::AudioProcessor::LOUDNESS}"
  end

  def base_filename
    File.basename(filename, file_extension)
  end

  def file_extension
    File.extname(filename)
  end

  def filename
    raise NotImplementedError
  end
end
