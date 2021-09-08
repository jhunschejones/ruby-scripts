require "fileutils"

Test::Unit.at_start do
  # this setup runs once at the start
  AUDIO_WATCH_DIRECTORY = "test/fixture_files"
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
end

class AudioProcessorTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
  end

  def teardown
    # this teardown runs after each test
  end

  def test_process_event_removes_unsafe_characters_from_file_names
    unsafe_file_name = "test/fixture_files/18622$_test.mp3"
    safe_file_name = unsafe_file_name.gsub("$", "")
    FileUtils.cp("test/fixture_files/18622.mp3", unsafe_file_name)

    AudioProcessor.new(unsafe_file_name, :created).process_event
    assert File.exist?(safe_file_name)

    # cleanup
    File.delete(safe_file_name)
  end
end
