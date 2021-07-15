require "test/unit"
require_relative "./filter"

Test::Unit.at_start do
  # this setup runs once at the start
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
end

class FilterTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
  end

  def teardown
    # this teardown runs after each test
  end

  def test_doesnt_change_string_when_no_characters_match
    expected_output = "Don't use the filtered letter"
    test_output = Filter.remove("Don't use the filtered letter")
    assert_equal expected_output, test_output
  end

  def test_removes_default_filter_characters
    expected_output = "This string hs some 's in it"
    test_output = Filter.remove("This string has some a's in it")
    assert_equal expected_output, test_output
  end

  def test_removes_custom_characters
    expected_output = "Tis string as some a's in it"
    test_output = Filter.remove("This string has some a's in it", ["h"])
    assert_equal expected_output, test_output
  end
end
