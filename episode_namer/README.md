# Episode Namer

## Overview
This is a quick script that renames show episode files in a directory. The file structure I started with did not have the episode names in them, so it allows for names to be manually entered.

## To use:
1. Place episode files in the `./episodes` directory
2. Check the regex in `./lib/episode.rb` to make sure it will match out the parts of the file name you need
3. Run `ruby episode_namer.rb` from the root of this project

BONUS: Run `ruby exif_namer.rb` to add names to the exif data of `.mp4` files

## Limitations:
* Currently there is only one regex for pulling data out of the file name and it is hard-coded in the `./lib/episode.rb` class. You will need to create a regex matching any other specific file naming convention prior to running the script (perhaps using a tool like [https://rubular.com/](https://rubular.com/)).
* The program requires exiftool to be installed, which you can do by following [these instructions](https://exiftool.org/install.html).
* `exiftool` currently does not support writing to `.mkv` files, which is what I was working with when I wrote this script. As a result, the script is hard-coded to only attempt to modify exif data on `.mp4` files.
