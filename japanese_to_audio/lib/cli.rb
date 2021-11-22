class Cli
  def initialize
    unless Dir.exist?(Synthesizer::AUDIO_OUTPUT_FOLDER)
      raise "Invalid output folder: #{Synthesizer::AUDIO_OUTPUT_FOLDER}"
    end
    puts "====== WELCOME TO THE JAPANESE TO AUDIO CONVERTER =====".cyan
  end

  def run
    loop do
      puts "Provide some Japanese to convert to audio:"
      print "> "
      japanese = Japanese.new(user_input)

      unless japanese.is_valid?
        puts "Sorry, I couldn't recognize '#{japanese}'".red
        next
      end

      puts "What would you like to name the output file?"
      print "> "
      filename = user_input

      synthesizer = Synthesizer.new(
        japanese: japanese,
        filename: filename
      )

      # escaping spaces in the file so that the output is copy-paste-able into
      # other terminal commands
      destination_file = synthesizer.convert_japanese_to_audio.gsub(/\s/, "\\ ")
      puts "Generated #{destination_file} 🎉".green
    end
  rescue Interrupt
    puts "\nBye!".cyan
    exit 0
  end

  private

  def user_input
    input = $stdin.gets.chomp
    if ["QUIT", "Q", "EXIT"].include?(input.upcase)
      puts "Bye!".cyan
      exit 0
    end
    input
  end
end
