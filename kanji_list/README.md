# Kanji List

Kanji List is a dead-simple script that I am building as I create flashcards for studying Japanese. I needed a way to quickly see the unique kanji in a new set of vocabulary that I'm studying, while taking into account what kanji I've already made cards for.

## In Use
* To add a kanji, run `./scripts/add_kanji.rb 形` with the new character to add at the end. This will add the kanji to the database with a status of `card_created`.
* To skip a kanji, run `./scripts/add_kanji.rb 形` with the new character to skip at the end. This will add the kanji to the database with a status of `skipped`.
* To see the next unique kanji in a list of words, modify the word list in `./scripts/next_kanji.rb` then run `./scripts/next_kanji.rb`.
