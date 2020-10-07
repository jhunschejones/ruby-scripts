#!/usr/bin/env ruby
require_relative '../module_loader'

unless ARGV[0]
  raise "Pass a kanji as an argument to add it to the database"
end

# ARGV.each do |new_kanji|
#   begin
#     Kanji.create!(character: new_kanji.strip, status: Kanji::CARD_CREATED_STATUS)
#   rescue ActiveRecord::RecordInvalid => e
#     p new_kanji
#     p e.message
#   end
# end

begin
  p Kanji.create!(character: ARGV[0].strip, status: Kanji::CARD_CREATED_STATUS)
rescue ActiveRecord::RecordInvalid => e
  p e.message
end
