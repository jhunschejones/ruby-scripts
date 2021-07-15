class Filter
  CHARACTERS_TO_REMOVE = ["a"]
  def self.remove(string, characters_to_remove=CHARACTERS_TO_REMOVE)
    characters_to_remove.each do |remove_character|
      string.gsub!(remove_character, "")
    end
    string
  end
end
