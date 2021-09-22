require_relative "../test_helper"

class ModelTest < Test::Unit::TestCase
  def test_says_hello
    assert_equal Model.new.say_hello, "hello"
  end
end
