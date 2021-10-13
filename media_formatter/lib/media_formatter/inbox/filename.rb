module Inbox
  module Filename

    protected

    def safe_audio_filename
      if File.exist?("#{AUDIO_WATCH_DIRECTORY}/#{basename}#{extension}")
        "#{AUDIO_WATCH_DIRECTORY}/#{basename}_#{SecureRandom.uuid}#{extension}"
      else
        "#{AUDIO_WATCH_DIRECTORY}/#{basename}#{extension}"
      end
    end

    def safe_image_filename
      if File.exist?("#{IMAGE_WATCH_DIRECTORY}/#{basename}#{extension}")
        "#{IMAGE_WATCH_DIRECTORY}/#{basename}_#{SecureRandom.uuid}#{extension}"
      else
        "#{IMAGE_WATCH_DIRECTORY}/#{basename}#{extension}"
      end
    end

    def basename
      File.basename(filename, extension)
    end

    def extension
      File.extname(filename)
    end

    def filename
      raise NotImplementedError
    end
  end
end
