#!/usr/bin/env ruby
require_relative '../module_loader'

unless ARGV[0]
  raise "Pass a kanji as an argument to add it to the database"
end

p Kanji.skip(ARGV[0].strip)
