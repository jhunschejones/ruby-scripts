# Movie Formatter

## Overview
This is a script I use to rename movie files to a standardized format. The intended outcomes of running the script are as follows:
1. Movies should be named in the format `Movie Title (YEAR) [RESOLUTION]`
2. Any extra files besides the video file and subtitles should be deleted
3. If the target directory contains only the single video file, it should be moved out of the directory and the directory can be deleted
4. If the target directory contains a video file and a subtitles file, both files and the directory should be renamed to the new format

## To Use
1. Put directories with video files into the `./to_format` directory
2. Add strings to `./configuration.yml` that you want removed from file names
3. From the root of the project run `ruby movie_formatter.rb`

## Limitations
* The script expects that each video file to be processed in `./to_format` is nested in it's own, separate directory.
* There is a lot of directory changing going on in this script, so moving the files around may have unintended effects.
