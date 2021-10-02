require "yaml"
require "logger"
require "rake"
require "tty-prompt"
require "active_record"
require "aws-sdk-s3"
require "aws-sdk-sns"
require "pcloud_api"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == "main.rb"
end

WORD_LIST_KEY = "new_words".freeze
LOCAL_DB_FILENAME = YAML::load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])["database"]

if ENV["SCRIPT_ENV"] == "development"
  WORD_LIST_YAML_PATH = "config/word_list.yml".freeze
  KANJI_YAML_DUMP_PATH = "db/kanji_list_dump.yml".freeze
  AWS_BUCKET = "kanji-list".freeze
  KANJI_LIST_PCLOUD_FOLDER_ID = ENV["KANJI_LIST_PCLOUD_FOLDER_ID"].to_i
  KANJI_LIST_PCLOUD_ARCHIVE_FOLDER_ID = ENV["KANJI_LIST_PCLOUD_ARCHIVE_FOLDER_ID"].to_i
elsif ENV["SCRIPT_ENV"] == "test"
  WORD_LIST_YAML_PATH = "config/test_word_list.yml".freeze
  KANJI_YAML_DUMP_PATH = "db/test_kanji_list_dump.yml".freeze
  AWS_BUCKET = "test-kanji-list" # Doesn't actually exist
  KANJI_LIST_PCLOUD_FOLDER_ID = nil # Doesn't exist
  KANJI_LIST_PCLOUD_ARCHIVE_FOLDER_ID = nil # Doesn't exist
else
  raise "Unrecognized environment '#{ENV["SCRIPT_ENV"]}'"
end

# Make rake tasks availibile for the CLI and unit tests
load "lib/tasks/db.rake"
Rake::Task.define_task(:environment)

# Load state from pcloud before connecting to the database
Rake::Task["db:download_from_pcloud"].invoke unless ENV["SCRIPT_ENV"] == "test"
require_relative "../db/connection"
ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["LOG_QUERIES"]
$logger = Logger.new("tmp/log.txt") unless ENV["SCRIPT_ENV"] == "test"

File.write(WORD_LIST_YAML_PATH, "#{WORD_LIST_KEY}: []") unless File.exist?(WORD_LIST_YAML_PATH)
