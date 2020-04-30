require_relative "./lib/module_loader"

episodes = []
Dir.chdir("./episodes")
Dir.entries('.').each { |file| episodes << Episode.from_file(file) if file[0] != "." }

episodes.sort_by(&:number).each do |episode|
  puts "Episode #{episode.number} name:"
  print "> "
  episode.name = $stdin.gets.chomp

  if File.extname(episode.file) == ".mp4"
    system("exiftool", %{-title=#{episode.name}}, episode.file)
    File.delete("#{episode.file}_original") # remove up backup file created by exiftool
  end

  File.rename(episode.file, episode.formatted_file_name)
end
