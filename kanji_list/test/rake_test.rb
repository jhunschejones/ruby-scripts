require "rake"
require "fileutils"

Test::Unit.at_start do
  load "lib/tasks/db.rake"
  Rake::Task.define_task(:environment)
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
end

class RakeTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
    IO.any_instance.stubs(:puts)
  end

  def teardown
    # this teardown runs after each test
    IO.any_instance.unstub(:puts)
  end

  def test_upload_to_s3_dumps_db_yaml_and_uploads_two_files
    client_stub = Aws::S3::Client.new(stub_responses: true)
    resource_stub = Aws::S3::Resource.new(client: client_stub)
    Aws::S3::Resource.expects(:new).times(2).returns(resource_stub)

    Rake::Task["db:dump_to_yaml"].expects(:invoke).once
    Rake::Task["db:upload_to_s3"].invoke
  end

  def test_download_from_s3_downloads_two_files
    client_stub = Aws::S3::Client.new(stub_responses: true)
    client_stub.expects(:get_object).times(2)
    Aws::S3::Client.expects(:new).returns(client_stub)

    # Move the DB file before it gets overwritten
    FileUtils.mv("./db/local-test.db", "./tmp/local-test.db")

    Rake::Task["db:download_from_s3"].invoke

    # Put the DB file back
    FileUtils.mv("./tmp/local-test.db", "./db/local-test.db")
  end

  def test_report_totals_to_sns_posts_sns_message
    client_stub = Aws::S3::Client.new(stub_responses: true)
    resource_stub = Aws::SNS::Resource.new(client: client_stub)
    resource_stub.expects(:topic).returns(resource_stub)
    resource_stub.expects(:publish).once
    Aws::SNS::Resource.expects(:new).returns(resource_stub)

    Rake::Task["db:report_totals_to_sns"].invoke
  end
end
