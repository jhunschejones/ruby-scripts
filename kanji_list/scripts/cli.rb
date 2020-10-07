#!/usr/bin/env ruby
require_relative '../module_loader'

def menu
  system("clear")
  puts "- Welcome to Kanji List! -"
  puts "=========================="
  puts "Options: (press ENTER to advance)"
  puts "1. Show next kanji"
  puts "2. Mark kanji as added"
  puts "3. Mark kanji as skipped"
  puts "4. Remove kanji from database"
  print "> "
end

def parse_user_input
  user_input = $stdin.gets.chomp.downcase
  return $quit = true if ["exit", "quit"].include?(user_input)

  if user_input == "1"
    puts Kanji.next || "No more new kanjis in the word list"
    $stdin.gets
  end

  if user_input == "2"
    puts "Kanji to add:"
    print "> "
    p Kanji.add($stdin.gets.strip)
    $stdin.gets
  end

  if user_input == "3"
    puts "Kanji to skip:"
    print "> "
    p Kanji.skip($stdin.gets.strip)
    $stdin.gets
  end

  if user_input == "4"
    puts "Kanji to remove:"
    print "> "
    p Kanji.remove($stdin.gets.strip)
    $stdin.gets
  end
end

$quit = false

until $quit
  menu()
  parse_user_input()
end

puts "Bye!"
