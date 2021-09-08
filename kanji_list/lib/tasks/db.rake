namespace :db do
  desc "Dump the database to a yaml file"
  task :dump_to_yaml do
    puts "Dumping database to ./#{KANJI_YAML_DUMP_PATH}".yellow
    Kanji.dump_to_yaml
  end

  desc "Reset the database from a yaml file"
  task :load_from_yaml do
    puts "Loading database from ./#{KANJI_YAML_DUMP_PATH}".yellow
    Kanji.load_from_yaml_dump
  end

  desc "Upload the database file and YAML dump to S3"
  task :upload_to_s3 do
    db_file_name = YAML::load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])["database"]

    puts "Uploading ./#{db_file_name} to S3".yellow
    Aws::S3::Resource.new
      .bucket(AWS_BUCKET)
      .object(db_file_name.split("/").last)
      .upload_file("./#{db_file_name}")

    Rake::Task["db:dump_to_yaml"].invoke
    puts "Uploading ./#{KANJI_YAML_DUMP_PATH} to S3".yellow
    Aws::S3::Resource.new
      .bucket(AWS_BUCKET)
      .object(KANJI_YAML_DUMP_PATH.split("/").last)
      .upload_file("./#{KANJI_YAML_DUMP_PATH}")
  end

  desc "Download the database file and YAML dump from S3"
  task :download_from_s3 do
    db_file_name = YAML::load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])["database"]
    client = Aws::S3::Client.new

    puts "Downloading ./#{db_file_name} from S3".yellow
    File.open("./#{db_file_name}", "wb") do |file|
      client.get_object({ bucket: AWS_BUCKET, key: db_file_name.split("/").last }, target: file)
    end

    puts "Downloading ./#{KANJI_YAML_DUMP_PATH} from S3".yellow
    File.open("./#{KANJI_YAML_DUMP_PATH}", "wb") do |file|
      client.get_object({ bucket: AWS_BUCKET, key: KANJI_YAML_DUMP_PATH.split("/").last }, target: file)
    end
  end

  desc "Count completed kanji and send to SNS"
  task :report_totals_to_sns do
    kanji_count_message = "#{Kanji.added.count} kanjis have been added with #{Kanji.remaining_characters.size} left to add as of #{Time.now.strftime("%B %d, %Y, %I:%M%P")}"
    Aws::SNS::Resource
      .new(region: ENV["AWS_REGION"])
      .topic("arn:aws:sns:us-east-2:050810144108:kanji-reports-topic")
      .publish({ message: kanji_count_message })
    puts "Kanji report sent!".yellow
  end
end
