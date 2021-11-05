class Synthesizer
  class InvalidJapanese < StandardError; end

  POLLY = Aws::Polly::Client.new.freeze
  FEMALE_VOICE_ID = "Mizuki".freeze
  MALE_VOICE_ID = "Takumi".freeze
  VOICE_SPEED = "slow" # x-slow, slow, medium, fast, or x-fast
  AUDIO_OUTPUT_FOLDER = ENV.fetch("AUDIO_OUTPUT_FOLDER").freeze

  NON_WORD_NON_SPACE_CHARACTERS = /[^\w\s一-龯ぁ-んァ-ン０-９Ａ-ｚ]/.freeze

  def initialize(japanese:, filename: nil)
    @japanese = japanese
    @filename = filename
  end

  def convert_japanese_to_audio
    raise InvalidJapanese unless is_valid_japanese?

    source = POLLY
      .synthesize_speech({
        output_format: "mp3",
        text: "<speak><prosody rate='#{VOICE_SPEED}'>#{@japanese.to_s}</prosody></speak>",
        voice_id: FEMALE_VOICE_ID,
        text_type: "ssml"
      })
      .audio_stream

    IO.copy_stream(source, destination_file)
    destination_file
  end

  private

  def safe_filename
    @safe_filename ||= begin
      return default_filename if @filename.nil? || @filename.empty?
      safe_filename = File
        .basename(@filename, ".*") # remove file extensions
        .gsub(NON_WORD_NON_SPACE_CHARACTERS, "")
      safe_filename.empty? ? default_filename : safe_filename
    end
  end

  def destination_file
    "#{AUDIO_OUTPUT_FOLDER}/#{safe_filename}.mp3"
  end

  def default_filename
    # Use a millisecond timestamp as the default filename if the user did not
    # provide a valid filename.
    (Time.now.to_f * 1000).to_i.to_s
  end

  def is_valid_japanese?
    return false unless @japanese.is_a?(Japanese)
    return false unless @japanese.is_valid?
    true
  end
end
