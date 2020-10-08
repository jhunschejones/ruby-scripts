# Kanji List

Kanji List is a dead-simple script that I am building as I create flashcards for studying Japanese. I needed a way to quickly see the unique kanji in a new set of vocabulary that I'm studying, while taking into account what kanji I've already made cards for.

## In Use

There are two main ways to interact with this repo. The first is to use the one-off scripts for preforming single operations. The other is to use the interactive CLI which will allow you to add, skip, and remove kanjis from the database as well as viewing the next unique kanji based on the wordlist in `./config/word_list.yml`.

* To add a kanji, run `./bin/add_kanji.rb 形` with the new character to add at the end. This will add the kanji to the database with a status of `card_created`.
* To skip a kanji, run `./bin/add_kanji.rb 形` with the new character to skip at the end. This will add the kanji to the database with a status of `skipped`.
* To see the next unique kanji in a list of words, modify the `new_words` list in `./config/word_list.yml` then run `./bin/next_kanji.rb`.
* To use the interactive CLI, run `./bin/cli.rb`

BONUS: The Rakefile also includes commands to dump the local database to a yaml file and re-create the database from a yaml file.
