# ./local_parse.rb explanation
#
# Required state:
# `./tmp/reviews.json`: the exported reviews JSON from your jpdb.io account
#
# Output state:
# `./tmp/daily_study_time.txt`: daily review minutes (also printed to standard out)

require "json"
require "date"

# Some styled CLI output options
class String
  def red;     "\e[31m#{self}\e[0m" end
  def green;   "\e[32m#{self}\e[0m" end
  def black;   "\e[30m#{self}\e[0m" end
  def magenta; "\e[35m#{self}\e[0m" end
  def brown;   "\e[33m#{self}\e[0m" end
  def blue;    "\e[34m#{self}\e[0m" end
  def cyan;    "\e[36m#{self}\e[0m" end
  def gray;    "\e[37m#{self}\e[0m" end
  def bold;    "\e[1m#{self}\e[22m" end
end

DAILY_STUDY_TIME_RELATIVE_PATH = "./tmp/daily_study_time.txt".freeze
REVIEWS_RELATIVE_PATH = "./tmp/reviews.json".freeze

reviews_file_path = File.expand_path(REVIEWS_RELATIVE_PATH)
raise "Missing #{reviews_file_path}".red unless File.exists?(reviews_file_path)
reviews_json = JSON.parse(File.read(reviews_file_path))

review_categories = reviews_json.keys
review_timestamps = review_categories.flat_map do |review_category|
  reviews_json[review_category].flat_map do |entry|
    entry["reviews"].map { |review| review["timestamp"] }
  end
end

review_minutes_per_day = Hash.new {|h, k| h[k] = [] }
review_timestamps.uniq.each do |timestamp|
  # round timestamps to the nearest minute
  rounded_time = Time.at(timestamp - (timestamp % 60))
  date = rounded_time.to_s.split.first
  review_minutes_per_day[date] << rounded_time.to_i
end

review_days = review_minutes_per_day.keys.sort.reverse
daily_study_time_entries = []

puts "Here are your jpdb.io daily study time stats:".cyan
review_days.each do |review_day|
  study_minutes = review_minutes_per_day[review_day].uniq.size
  daily_study_time_entries << "Date: #{review_day}, Total minutes: #{study_minutes}"
  puts "#{"Date:".gray} #{review_day}#{", Total minutes:".gray} #{study_minutes.to_s.bold}"
end

File.open(DAILY_STUDY_TIME_RELATIVE_PATH, "w+") do |f|
  f.puts("Daily jpdb.io study time generated on: #{Date.today}")
  f.puts("=================================================")
  f.puts(daily_study_time_entries)
end

if ENV["KEEP_DAILY_STUDY_TIME"]
  # Optionally copy the file into the project directory to be commited
  FileUtils.cp(DAILY_STUDY_TIME_RELATIVE_PATH, "./daily_study_time.txt")
end
