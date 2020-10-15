# Image Formatter

### Overview
Image Formatter is a script that I run in the console while creating flashcards for learning Japanese. As a part of my card creation process, I download pneumonic images for each new word I'm learning. Previously, I was re-sizing and optimizing the files by hand after downloading them. This required a lot of clicks per flashcard and subtly burned down my energy in the background with hundreds of small, repetitive decisions over a single card-creation session.

Image Formatter helps with this process by watching the directory where I download images for my flashcards. When a new image arrives, it checks if it is a supported file format, and if the image height and file size match my target settings. If not, it uses the [Tinyify API](https://tinypng.com/developers) to optimize and re-size the image for me and moves the original image into a backup directory so it's out of the way. This changes my image download and optimization process from the slowest to one of the fastest steps in the card creation workflow, and saves my mental energy for the steps I actually care about _(like coming up with memorable pneumonics!)_

### In Use
To use the script, make sure the `WATCH_DIRECTORY` and `BACKUP_FILES_PATH` constants are pointed at existing paths _(the script will warn you if they aren't.)_ You will also need a [Tinyify API key](https://tinypng.com/developers) exported as the `TINIFY_API_KEY` environment variable. Then, simply start the script with `./bin/run`, download images to the `WATCH_DIRECTORY` and watch Image Formatter do it's work!
