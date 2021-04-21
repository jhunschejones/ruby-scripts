require "yaml"
require "logger"
require "tty-prompt"
require "active_record"
require "aws-sdk-s3"
require "rspotify"
require_relative "../db/connection"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require(f) }

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["LOG_QUERIES"]
$logger = Logger.new("tmp/log.txt")

RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
