require "fileutils"
require_relative "string_utils"

# change into the SD card
Dir.chdir("/Volumes/Untitled")

# logic for videos
if Dir.entries(".").include?("PRIVATE")
  files_by_date = Hash.new { |h, key| h[key] = [] }

  Dir.chdir("./PRIVATE/M4ROOT/CLIP")
  Dir.entries(".").each do |video_file|
    next if video_file[0] == "." # skip dot files

    created_at = File.birthtime(video_file).strftime("%Y-%m-%d")
    files_by_date[created_at] << video_file
  end

  files_by_date.keys.each do |created_at|
    folder_for_date = FileUtils.mkdir_p("#{File.join(Dir.home, "Desktop")}/#{created_at}/videos")[0]
    puts "Copying video files for #{created_at}...".cyan

    files_by_date[created_at].each do |file|
      print "#{file},".gray
      FileUtils.cp(file, "#{folder_for_date}/#{file}")
    end
    puts ""
  end
end

# change into the SD card
Dir.chdir("/Volumes/Untitled")

# logic for photos
if Dir.entries(".").include?("DCIM")
  Dir.chdir("./DCIM")

  Dir.entries(".").each do |photos_folder|
    next if photos_folder[0] == "." # skip dot files
    Dir.chdir(photos_folder)

    files_by_date = Hash.new { |h, key| h[key] = [] }

    Dir.entries(".").each do |photo_file|
      next if photo_file[0] == "." # skip dot files

      created_at = File.birthtime(photo_file).strftime("%Y-%m-%d")
      files_by_date[created_at] << photo_file
    end

    files_by_date.keys.each do |created_at|
      folder_for_date = FileUtils.mkdir_p("#{File.join(Dir.home, "Desktop")}/#{created_at}/photos")[0]
      puts "Copying photos for #{created_at}...".cyan

      files_by_date[created_at].each do |file|
        print "#{file},".gray
        FileUtils.cp(file, "#{folder_for_date}/#{file}")
      end
      puts ""
    end
  end
end
