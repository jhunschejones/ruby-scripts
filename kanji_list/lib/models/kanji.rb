class Kanji < ActiveRecord::Base
  ADDED_STATUS = "added".freeze
  SKIPPED_STATUS = "skipped".freeze
  KANJI_REGEX = /[一-龯]/.freeze

  validates :character, presence: true, uniqueness: true, format: { with: KANJI_REGEX }

  class << self
    def add(new_kanji)
      begin
        new_kanji = Kanji.create!(
          character: new_kanji&.strip,
          status: ADDED_STATUS
        )
        $logger.debug("Added: #{new_kanji.inspect}") if $logger
        new_kanji
      rescue ActiveRecord::RecordInvalid => e
        e.message
      end
    end

    def skip(new_kanji)
      begin
        skipped_kanji = Kanji.create!(
          character: new_kanji&.strip,
          status: SKIPPED_STATUS
        )
        $logger.debug("Skipped: #{skipped_kanji.inspect}") if $logger
        skipped_kanji
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
      new_characters = YAML::load(File.open(WORD_LIST_YAML_PATH))[WORD_LIST_KEY]
        .flat_map { |word| word.split("") }
        .uniq
        .select { |kanji| kanji =~ KANJI_REGEX }

      new_characters - previous_characters
    end

    def dump_to_yaml
      File.open(KANJI_YAML_DUMP_PATH, "w") do |file|
        file.write(
          {
            "added_kanji" => Kanji.where(status: ADDED_STATUS).pluck(:character),
            "skipped_kanji" => Kanji.where(status: SKIPPED_STATUS).pluck(:character)
          }.to_yaml
        )
      end
    end

    def load_from_yaml_dump
      dump = YAML::load(File.open(KANJI_YAML_DUMP_PATH))
      Kanji.destroy_all
      dump["added_kanji"].each { |kanji| p Kanji.add(kanji) }
      dump["skipped_kanji"].each { |kanji| p Kanji.skip(kanji) }
    end
  end

  def add!
    begin
      self.status = ADDED_STATUS
      self.save!
      $logger.debug("Added: #{self.inspect}") if $logger
      self
    rescue ActiveRecord::RecordInvalid => e
      e.message
    end
  end

  def skip!
    begin
      self.status = SKIPPED_STATUS
      self.save!
      $logger.debug("Skipped: #{self.inspect}") if $logger
      self
    rescue ActiveRecord::RecordInvalid => e
      e.message
    end
  end
end
