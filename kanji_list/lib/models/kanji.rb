class Kanji < ActiveRecord::Base
  ADDED_STATUS = "added".freeze
  SKIPPED_STATUS = "skipped".freeze
  NON_KANA_OR_NUMBER_REGEX = /([^ぁ-んァ-ン０-９])/.freeze

  validates :character, presence: true, uniqueness: true

  class << self
    def add(new_kanji)
      begin
        Kanji.create!(character: new_kanji&.strip, status: ADDED_STATUS)
      rescue ActiveRecord::RecordInvalid => e
        e.message
      end
    end

    def skip(new_kanji)
      begin
        Kanji.create!(character: new_kanji&.strip, status: SKIPPED_STATUS)
      rescue ActiveRecord::RecordInvalid => e
        e.message
      end
    end

    def remove(kanji)
      kanji_to_destroy = Kanji.find_by(character: kanji&.strip)
      return false unless kanji_to_destroy
      removed_kanji = kanji_to_destroy.destroy
      $logger.debug("Removed: #{removed_kanji.inspect}") if $logger
      removed_kanji
    end

    def next
      next_caracter = remaining_characters.first&.strip
      next_caracter ? new(character: next_caracter) : nil
    end

    def remaining_characters
      previous_characters = Kanji.pluck(:character)
      new_characters = YAML::load(File.open('config/word_list.yml'))["new_words"]
        .flat_map { |word| word.split("") }
        .uniq
        .select { |kanji| kanji =~ NON_KANA_OR_NUMBER_REGEX }
        
      new_characters - previous_characters
    end

    def dump_to_yaml
      File.open("db/kanji_list_dump.yml", "w") do |file|
        file.write(
          {
            "added_kanji" => Kanji.where(status: ADDED_STATUS).pluck(:character),
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

  def add!
    begin
      self.status = ADDED_STATUS
      self.save!
    rescue ActiveRecord::RecordInvalid => e
      e.message
    end
  end

  def skip!
    begin
      self.status = SKIPPED_STATUS
      self.save!
    rescue ActiveRecord::RecordInvalid => e
      e.message
    end
  end
end
