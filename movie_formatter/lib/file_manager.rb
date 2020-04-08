module FileManager
  def self.delete_extra_files
    Dir.entries('.').each do |dir|
      if dir[0] != '.' && File.directory?(dir)
        Dir.chdir("./#{dir}")

        Dir.entries('.').each do |file|
          # remove extra files
          if file[0] != '.' && [".jpg", ".txt", ".part"].include?(File.extname(file))
            File.delete(file)
          end

          # remove "Other" directory
          if file.upcase == "OTHER" && File.directory?(file)
            Dir.chdir("./#{file}")
            subtitles = Dir.entries('.').select { |f| File.extname(f) == ".srt" }

            # if there are subtitles in here, move them out first
            if subtitles.length > 0
              subtitles.each {|s| FileUtils.move("./#{s}", "../")}
            end

            Dir.chdir("..")
            FileUtils.remove_dir(file, true) # force delete directory
          end
        end

        Dir.chdir("..")
      end
    end
  end

  def self.rename_files
    # rename movie files and .srt files
    Dir.entries('.').each do |dir|
      if dir[0] != '.' && File.directory?(dir)
        Dir.chdir("./#{dir}")

        movie_name = MovieTitle.new(text: dig_for_movie_name(dir)).format.text

        # rename all files
        Dir.entries('.').each do |file|
          File.rename(file, movie_name + File.extname(file)) unless file[0] == '.'
        end

        Dir.chdir("..")

        # rename sub-directiory
        File.rename(dir, movie_name)
      end
    end
  end

  def self.organize_files
    # if there are no .srt files, move the movie file to the main directory and
    # delete its sub-directory if a .srt file exists, leave everything in the
    # sub-directory
    Dir.entries('.').each do |dir|
      if dir[0] != '.' && File.directory?(dir)
        Dir.chdir("./#{dir}")
        contents = Dir.entries('.').select {|file| file[0] != '.'}
        if contents.length < 2
          contents.each {|file| FileUtils.move("./#{file}", "../")}
          Dir.chdir("..")
          FileUtils.remove_dir(dir, true) # force delete directory
        else
          Dir.chdir("..")
        end
      end
    end
  end

  def self.dig_for_movie_name(dir)
    Dir.entries('.').each do |file|
      if file[0] != '.' && [".mp4", ".mkv"].include?(File.extname(file))
        return File.basename(file, ".*")
      end
    end
  end
end
