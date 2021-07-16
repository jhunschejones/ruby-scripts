class Song
  STANZA_LENGTH = 4.freeze
  STANZA_COUNT = 4.freeze

  def initialize
    @lyric_lines = []
    @direction_lines = []

    Dir.entries("./lyrics").each do |file|
      next if file[0] == "."
      @lyric_lines += File
        .readlines("./lyrics/#{file}")
        .reject { |line| line.chomp.size == 0 }
    end

    Dir.entries("./directions").each do |file|
      next if file[0] == "."
      @direction_lines += File
        .readlines("./directions/#{file}")
        .reject { |line| line.chomp.size == 0 }
    end
  end

  def print
    STANZA_COUNT.times do |index|
      stanza.each { |line| puts line }
      puts "" unless index + 1 == STANZA_COUNT
    end
  end

  private

  def stanza
    stanza = []
    direction_line = rand(2..STANZA_LENGTH)

    STANZA_LENGTH.times do |index|
      if index + 1 == direction_line
        stanza << @direction_lines.sample
      else
        stanza << @lyric_lines.sample
      end
    end
    stanza
  end
end
