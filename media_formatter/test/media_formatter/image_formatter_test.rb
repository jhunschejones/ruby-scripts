require "fileutils"

Test::Unit.at_start do
  # this setup runs once at the start
  IMAGE_WATCH_DIRECTORY = "test/fixture_files"
  BACKUP_IMAGE_FILES_PATH = "test/fixture_files/backups"
  Dir.mkdir(BACKUP_IMAGE_FILES_PATH)
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
  FileUtils.rm_rf(BACKUP_IMAGE_FILES_PATH)
end

class ImageFormatterTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
    IO.any_instance.stubs(:puts)

    @test_file = "test/fixture_files/goats_in_action_test.jpeg"
    @resized_test_file = "test/fixture_files/goats_in_action_test_resized.jpeg"
    FileUtils.cp("test/fixture_files/goats_in_action.jpeg", @test_file)
  end

  def teardown
    # this teardown runs after each test
    IO.any_instance.unstub(:puts)

    File.delete(@test_file) if File.exist?(@test_file)
    File.delete(@resized_test_file) if File.exist?(@resized_test_file)
  end

  def test_process_event_backs_up_origional_image
    ImageFormatter.new(@test_file, :created).process_event
    assert File.exists?(@resized_test_file)
  end

  def test_process_event_resizes_images_that_are_too_tall
    refute Image.new(@test_file).height == ImageFormatter::TARGET_HEIGHT_PX
    ImageFormatter.new(@test_file, :created).process_event
    assert Image.new(@resized_test_file).height == ImageFormatter::TARGET_HEIGHT_PX
  end
end
