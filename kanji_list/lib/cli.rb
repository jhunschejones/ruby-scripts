class CLI
  MENU_OPTIONS = [
    SHOW_NEXT_CHARACTER_OPTION = "Next character from word list",
    ADD_TO_WORD_LIST_OPTION = "Add new words to word list",
    ADVANCED_OPTION = "More options",
    QUIT_OPTION = "Quit"
  ].freeze
  NEXT_KANJI_OPTIONS = ["Open URLs", "Add", "Skip", "Back"].freeze
  ADVANCED_OPTIONS = [
    TOTALS_OPTION = "Total kanji count",
    ADD_OPTION = "Add kanji (freeform)",
    SKIP_OPTION = "Skip kanji (freeform)",
    REMOVE_OPTION = "Remove kanji (freeform)",
    BACK_OPTION = "Back".freeze
  ].freeze

  def initialize
    @prompt = TTY::Prompt.new(
      interrupt: Proc.new do
        puts "\n#{total_kanji_added_message}"
        exit 0
      end,
      active_color: :green,
      track_history: false
    )
  end

  def run
    loop do
      case @prompt.select(
        "What would you like to do? #{new_characters_remaining_message}",
        menu_options,
        filter: true,
        cycle: true
      )
      when SHOW_NEXT_CHARACTER_OPTION
        next_new_character_menu
      when ADD_TO_WORD_LIST_OPTION
        add_new_words_to_word_list
      when ADVANCED_OPTION
        advanced_menu
      when QUIT_OPTION
        puts total_kanji_added_message
        exit 0
      end
    end
  end

  private

  def next_new_character_menu(open_urls: true)
    next_kanji = Kanji.next
    options = open_urls ? NEXT_KANJI_OPTIONS : NEXT_KANJI_OPTIONS.dup - ["Open URLs"]

    # copy the next character to the clipboard (without newline)
    system("echo #{next_kanji.character} | tr -d '\n' | pbcopy")

    case @prompt.select("Next kanji: #{next_kanji.character.cyan}", options)
    when "Open URLs"
      system("open https://en.wiktionary.org/wiki/#{next_kanji.character}#Japanese")
      system("open https://app.kanjialive.com/#{next_kanji.character}")
      next_new_character_menu(open_urls: false)
    when "Add"
      next_kanji.add!
    when "Skip"
      next_kanji.skip!
    end
  end

  def advanced_menu
    case @prompt.select(
      "Advanced options:",
      ADVANCED_OPTIONS,
      filter: true,
      cycle: true
    )
    when TOTALS_OPTION
      puts total_kanji_added_message
    when ADD_OPTION
      kanji_to_add = Kanji.new(
        character: @prompt.ask("What kanji would you like to add?"),
        status: Kanji::ADDED_STATUS
      )
      if kanji_to_add.save
        puts "Kanji added: #{kanji_to_add.character}".green
      else
        puts "#{kanji_to_add.character} #{kanji_to_add.errors.first.message}".red
      end
    when SKIP_OPTION
      kanji_to_skip = @prompt.ask("What kanji would you like to skip?")
      puts "Kanji skipped: #{Kanji.skip(kanji_to_skip).character}".green
    when REMOVE_OPTION
      kanji_to_remove = @prompt.ask("What kanji would you like to remove?")
      removed_kanji = Kanji.remove(kanji_to_remove)
      if removed_kanji
        puts "Removed kanji: #{removed_kanji.character}".yellow
      else
        puts "Unable to find kanji character: #{kanji_to_remove.inspect}".red
      end
    end
  end

  def menu_options
    Kanji.next ? MENU_OPTIONS : MENU_OPTIONS[1..-1]
  end

  def new_characters_remaining_message
    "(#{Kanji.remaining_characters.size} kanji remaining)".cyan
  end

  def total_kanji_added_message
    "Total kanji added: #{Kanji.where(status: Kanji::ADDED_STATUS).count}".cyan
  end

  def add_new_words_to_word_list
    new_words = @prompt
      .multiline("Add words separated by newlines or commas")
      .flat_map { |word| word.split(",").map(&:strip) }

    old_words = YAML::load(File.open(WORD_LIST_YAML_PATH))[WORD_LIST_KEY]

    File.open(WORD_LIST_YAML_PATH, "w") do |file|
      file.write({ WORD_LIST_KEY => (old_words + new_words).uniq }.to_yaml)
    end
  end
end
