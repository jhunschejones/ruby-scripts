require_relative '../app'

unless ARGV[0]
  raise "Pass a kanji as an argument to add it to the database"
end

begin
  p Kanji.create!(character: ARGV[0].strip, status: Kanji::SKIPPED_STATUS)
rescue ActiveRecord::RecordInvalid => e
  p e.message
end
