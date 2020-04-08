class MovieTitle
  STRINGS_TO_REMOVE = YAML.load(File.read("./configuration.yml"))["strings_to_remove"]

  attr_accessor :text

  def initialize(text:)
    @text = text
  end

  def format
    remove_periods()
    put_screen_resolution_in_brackets()
    remove_disallowed_strings()
    put_years_in_parens()
    remove_trailing_characters()
    clean_braces_and_parens()
    remove_extra_spaces()
    return self
  end

  private

  def remove_periods
    self.text = text.split('.').join(' ')
  end

  def put_screen_resolution_in_brackets
    # add brackets around 2160p, 1080p, and 720p, fix `p]p` created by accident
    self.text = text.gsub("2160", "[2160p]")
                    .gsub("1080", "[1080p]")
                    .gsub("720", "[720p]")
                    .gsub("p]p", "p]")
  end

  def remove_disallowed_strings
    STRINGS_TO_REMOVE.each do |string_to_remove|
      self.text = text.gsub(string_to_remove, "")
    end
  end

  def put_years_in_parens
    # find four digit numbers starting with 1 or 2
    years = text.scan(/[1-2]\d{3}/);

    if years.length > 0
      years.each do |year|
        unless ["1080", "2160"].include?(year)
          # if the number is not 2160 or 1080, add `()` around it
          # because its probably an actual year
          self.text = text.gsub(year, "(#{year})")
        end
      end
    end
  end

  def remove_trailing_characters
    if text.rindex("]")
      # remove everything after last `]` if there is one
      self.text = text[0, text.rindex("]") + 1]
    elsif text.rindex(")")
      # remove everything after last `)` if there is one
      self.text = text[0, text.rindex(")") + 1]
    end
  end

  def clean_braces_and_parens
    # 1. clean up double braces and parens
    # 2. clean up empty braces and parens
    self.text = text.gsub("[[", "[")
                    .gsub("]]", "]")
                    .gsub("((", "(")
                    .gsub("))", ")")
                    .gsub("[]", "")
                    .gsub("()", "")
  end

  def remove_extra_spaces
    self.text = text.split().join(" ")
  end
end
