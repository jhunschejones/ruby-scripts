class Kanji < ActiveRecord::Base
  CARD_CREATED_STATUS = "card_created".freeze
  SKIPPED_STATUS = "skipped".freeze

  validates :character, presence: true, uniqueness: true

  class << self
    def add(new_kanji)
      begin
        Kanji.create!(character: new_kanji.strip, status: Kanji::CARD_CREATED_STATUS)
      rescue ActiveRecord::RecordInvalid => e
        e.message
      end
    end

    def skip(new_kanji)
      begin
        Kanji.create!(character: new_kanji.strip, status: Kanji::SKIPPED_STATUS)
      rescue ActiveRecord::RecordInvalid => e
        e.message
      end
    end

    def remove(kanji)
      kanji_to_destroy = Kanji.find_by(character: kanji.strip)
      return "Unable to find kanji character: #{kanji}" unless kanji_to_destroy
      destroyed_kanji = kanji_to_destroy.destroy
      $logger.debug("Destroyed: #{destroyed_kanji.inspect}") if $logger
      destroyed_kanji
    end

    def next
      remaining_characters.first
    end

    def remaining_characters
      previous_kanji = Kanji.pluck(:character)
      new_words = YAML::load(File.open('config/word_list.yml'))["new_words"]
      new_words.flat_map {|word| word.split("") }.uniq - previous_kanji
    end

    def dump_to_yaml
      File.open("db/kanji_list_dump.yml", "w") do |file|
        file.write(
          {
            "added_kanji" => Kanji.where(status: CARD_CREATED_STATUS).pluck(:character),
            "skipped_kanji" => Kanji.where(status: SKIPPED_STATUS).pluck(:character)
          }.to_yaml
        )
      end
    end

    def load_from_yaml_dump
      dump = YAML::load(File.open("db/kanji_list_dump.yml"))
      Kanji.destroy_all
      dump["added_kanji"].each { |kanji| p Kanji.add(kanji) }
      dump["skipped_kanji"].each { |kanji| p Kanji.skip(kanji) }
    end
  end
end
