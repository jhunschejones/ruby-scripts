#!/usr/bin/env ruby
require_relative '../module_loader'

previous_kanji = Kanji.pluck(:character)
new_words = [
  "形容詞", "大人", "午後", "空", "空港", "健在", "動物", "部屋", "林檎", "４月", "腕", "軍", "術", "芸術家", "攻撃", "八月", "作家"
]

next_kanji = (new_words.flat_map {|word| word.split("") }.uniq - previous_kanji).first

if next_kanji
  puts "Next kanji:"
  puts next_kanji
else
  puts "No more new kanji in the word list"
end
