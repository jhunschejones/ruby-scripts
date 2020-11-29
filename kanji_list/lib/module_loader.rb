require "yaml"
require "logger"
require "tty-prompt"
require "active_record"
require_relative "../db/connection"

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require(f) }

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["LOG_QUERIES"]
$logger = Logger.new("tmp/log.txt")

WORD_LIST_YAML_PATH = "config/word_list.yml".freeze
WORD_LIST_KEY = "new_words".freeze
KANJI_YAML_DUMP_PATH = "db/kanji_list_dump.yml".freeze
