# Media Formatter

### Overview
Media Formatter is a script that I run in the console while creating flashcards for learning Japanese. As a part of my card creation process, I download pneumonic images for each new word I'm learning. Previously, I was re-sizing and optimizing the files by hand after downloading them. This required a lot of clicks per flashcard and subtly burned down my energy in the background with hundreds of small, repetitive decisions over a single card-creation session.

Media Formatter helps with this process by watching the directory where I download images for my flashcards. When a new image arrives, it checks if it is a supported file format, and if the image height and file size match my target settings. If not, it uses the [Tinyify API](https://tinypng.com/developers) to optimize and re-size the image for me and moves the original image into a backup directory so it's out of the way. This changes my image download and optimization process from the slowest to one of the fastest steps in the card creation workflow, and saves my mental energy for the steps I actually care about _(like coming up with memorable pneumonics!)_

### In Use
1. Make sure the `IMAGE_WATCH_DIRECTORY` and `BACKUP_IMAGE_FILES_PATH` constants are pointed at existing paths _(the script will create them in the OSX downloads directory if they do not exist.)_
2. You will also need a [Tinyify API key](https://tinypng.com/developers) exported as the `TINIFY_API_KEY` environment variable.
3. On OSX you can install imagemagick with `brew install imagemagick`

Once this setup is complete, simply start the script with `./bin/run`, download images to the `IMAGE_WATCH_DIRECTORY` and observe Media Formatter doing it's work! To run the script without actually making calls to the Tinyify API, use `DRY_RUN=true ./bin/run`.
