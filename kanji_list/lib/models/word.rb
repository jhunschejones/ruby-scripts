class Word
  class << self
    def find_by(kanji:)
      YAML::load(File.open(WORD_LIST_YAML_PATH))
        .fetch(WORD_LIST_KEY)
        .find { |word| word.include?(kanji.character) }
    end
  end
end
