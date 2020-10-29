class CLI
  MENU_OPTIONS = [
    SHOW_NEXT_OPTION = "Next from word list",
    ADVANCED_OPTION = "Advanced options",
    QUIT_OPTION = "Quit"
  ].freeze
  NEXT_KANJI_OPTIONS = ["Add", "Skip", "Back"].freeze
  ADVANCED_OPTIONS = [
    ADD_OPTION = "Add (freeform)",
    SKIP_OPTION = "Skip (freeform)",
    REMOVE_OPTION = "Remove (freeform)",
    TOTALS_OPTION = "Totals",
    BACK_OPTION = "Back".freeze
  ].freeze

  def initialize
    @prompt = TTY::Prompt.new(interrupt: :exit, active_color: :green)
  end

  def run
    loop do
      case @prompt.select("What would you like to do? #{kanji_remaining_message}", menu_options)
      when SHOW_NEXT_OPTION
        next_kanji_menu
      when ADVANCED_OPTION
        advanced_menu
      when QUIT_OPTION
        exit 0
      end
    end
  end

  private

  def menu_options
    Kanji.next ? MENU_OPTIONS : MENU_OPTIONS[1..-1]
  end

  def kanji_remaining_message
    "(#{Kanji.remaining_characters.size} kanji remaining)".cyan
  end

  def next_kanji_menu
    next_kanji = Kanji.next
    case @prompt.select("Next kanji: #{next_kanji.character.cyan}", NEXT_KANJI_OPTIONS)
    when "Add"
      next_kanji.add!
    when "Skip"
      next_kanji.skip!
    end
  end

  def advanced_menu
    case @prompt.select("Advanced options:", ADVANCED_OPTIONS)
    when ADD_OPTION
      kanji_to_add = @prompt.ask("What kanji would you like to add?")
      puts "Kanji added: #{Kanji.add(kanji_to_add).character}".green
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
    when TOTALS_OPTION
      puts "Total kanji added: #{Kanji.where(status: Kanji::ADDED_STATUS).count}".cyan
    end
  end
end
