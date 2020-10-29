# Kanji List

Kanji List is a script that I am using with a local database as I create flashcards for studying Japanese. I created this as a way to quickly see the unique kanji in a new set of vocabulary that I'm studying, while taking into account what kanji I've already made cards for.

## In Use

This script runs an interactive CLI which will allow you to add, skip, and remove kanjis from the database as well as viewing the next unique kanji based on the wordlist in `./config/word_list.yml`. To launch the CLI, simply run `./bin/run`. The Rakefile also includes a couple custom commands to dump the local database to a yaml file or to re-create the database from a yaml file. These can be used for easy backup and restore processes that are less dependent on the DB structure for the project.
