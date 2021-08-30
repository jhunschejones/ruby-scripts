require "test/unit"
require_relative "../../lib/module_loader.rb"

Test::Unit.at_start do
  # this setup runs once at the start
  File.write(KANJI_YAML_DUMP_PATH, "added_kanji: ['形']\nskipped_kanji: []")
  Kanji.load_from_yaml_dump
  File.write(WORD_LIST_YAML_PATH, "#{WORD_LIST_KEY}: ['取り']")
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
  File.delete(WORD_LIST_YAML_PATH)
  File.delete(KANJI_YAML_DUMP_PATH)
end

class KanjiTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
  end

  def teardown
    # this teardown runs after each test
  end

  def test_next_returns_next_character
    assert_equal "取", Kanji.next.character
  end
end
