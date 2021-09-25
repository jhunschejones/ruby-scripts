require "httparty"
require "json"
require "pry"
require "digest"
require_relative "./string_utils.rb"

ACCESS_TOKEN_PATH = "./tmp/access_token.txt".freeze

def should_exclude?(file)
  [
    "api_interactions.rb",
    "get_access_token.rb"
  ].include?(File.basename(file))
end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless should_exclude?(file)
end
