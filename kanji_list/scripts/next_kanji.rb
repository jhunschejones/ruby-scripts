#!/usr/bin/env ruby
require_relative '../module_loader'

next_kanji = Kanji.next

if next_kanji
  puts "Next kanji:"
  puts next_kanji
else
  puts "No more new kanji in the word list"
end
