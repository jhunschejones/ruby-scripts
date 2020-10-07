# Kanji List

Kanji List is a dead-simple script that I am building as I create flashcards for studying Japanese. I needed a way to quickly see the unique kanji in a new set of vocabulary that I'm studying, while taking into account what kanji I've already made cards for.

## In Use
Right now the script is simply run with `ruby kanji_list.rb`. To add new kanji, modify the arrays in the script for the new vocabulary words or for existing kanji as cards are created.

* To add a kanji, run `ruby ./script/add_kanji.rb 形` with the new character to add at the end. This will add the kanji to the database with a status of `card_created`.
* To skip a kanji, run `ruby ./script/add_kanji.rb 形` with the new character to skip at the end. This will add the kanji to the database with a status of `skipped`.
