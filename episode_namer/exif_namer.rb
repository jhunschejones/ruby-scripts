Dir.chdir("./episodes")
Dir.entries('.').each do |file|
  next if file[0] == "."

  puts "Episode name:"
  print "> "
  episode_name = $stdin.gets.chomp

  if File.extname(file) == ".mp4"
    system("exiftool", %{-title=#{episode_name}}, file)
  end
end

# Clean up backups created by exiftool
Dir.entries('.').each { |file| File.delete(file) if File.extname(file).include?("original") }
