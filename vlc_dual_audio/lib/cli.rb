require_relative "./string_utils"
SET_CLI_TO_GREEN = "\033[32m"
RESET_CLI_COLOR = "\033[0m"
LAST_AUDIO_TRACK = "--audio-track=1"
DISABLE_SUBTITLES = "--sub-track=100" # a number bigger than the total number of subtitle tracks

if `which vlc`.chomp == ""
  puts "Please first install the VLC CLI tool with `brew install vlc`".red
  exit 1
end

system("clear")

puts "====== Lets watch a movie with dual audio! ======".cyan
puts "(Follow the on-screen instructions and press ENTER to advance through the steps)\n".gray

puts "First, drag and drop the movie file you want to play:"
print "> #{SET_CLI_TO_GREEN}"
movie_file = $stdin.gets.chomp.strip
print RESET_CLI_COLOR
unless File.file?(movie_file.gsub("\\", ""))
  puts "Hmm, something doesn't look right about that movie file: '#{movie_file}'".red
  exit 1
end

puts "Now drag and drop the additional audio file:"
print "> #{SET_CLI_TO_GREEN}"
audio_file = $stdin.gets.chomp.strip
print RESET_CLI_COLOR
unless File.file?(audio_file.gsub("\\", ""))
  puts "Hmm, something doesn't look right about that audio file: '#{audio_file}'".red
  exit 1
end

puts "Optional: provide a number of milliseconds to delay the audio file, or press ENTER to skip:"
print "> #{SET_CLI_TO_GREEN}"
user_specified_delay_ms = $stdin.gets.chomp.strip
print RESET_CLI_COLOR
audio_delay_ms = user_specified_delay_ms.empty? ? 0 : user_specified_delay_ms

system("vlc #{movie_file} --input-slave #{audio_file} #{LAST_AUDIO_TRACK} #{DISABLE_SUBTITLES} --audio-desync=#{audio_delay_ms}")
