class FileEventProcessorTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
    IO.any_instance.stubs(:puts)
  end

  def teardown
    # this teardown runs after each test
    IO.any_instance.unstub(:puts)
  end

  def test_processes_a_single_enqueued_event
    mock_image_formatter = mock()
    mock_image_formatter.expects(:should_process_event?).once.returns(true)
    mock_image_formatter.expects(:process_event).once
    ImageFormatter.expects(:new).once.returns(mock_image_formatter)
    FileEventProcessor
      .new(interval: 0)
      .run
      .enqueue(FileEvent.new("test/fixture_files/goat_at_rest.jpeg", :created))
    sleep 0.2 # wait for queue to empty
  end

  def test_processes_a_list_of_enqueued_events
    number_of_events = 5
    mock_image_formatter = mock()
    mock_image_formatter.expects(:should_process_event?).times(number_of_events).returns(true)
    mock_image_formatter.expects(:process_event).times(number_of_events)
    ImageFormatter.expects(:new).times(number_of_events).returns(mock_image_formatter)

    file_event = FileEvent.new("test/fixture_files/goat_at_rest.jpeg", :created)
    events_to_process = []
    number_of_events.times { events_to_process << file_event }

    FileEventProcessor
      .new(interval: 0)
      .run
      .enqueue(events_to_process)
    sleep 0.2 # wait for queue to empty
  end
end
