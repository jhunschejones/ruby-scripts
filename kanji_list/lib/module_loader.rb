require "yaml"
require "logger"
require "tty-prompt"
require "active_record"
require "aws-sdk-s3"
require_relative "../db/connection"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == 'main.rb'
end

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["LOG_QUERIES"]
$logger = Logger.new("tmp/log.txt")

WORD_LIST_YAML_PATH = "config/word_list.yml".freeze
WORD_LIST_KEY = "new_words".freeze
KANJI_YAML_DUMP_PATH = "db/kanji_list_dump.yml".freeze
AWS_BUCKET = "kanji-list".freeze

File.write(WORD_LIST_YAML_PATH, "#{WORD_LIST_KEY}: []") unless File.exist?(WORD_LIST_YAML_PATH)
