# Time Offset

### Overview
While editing/mixing podcasts, I get client notes in a CSV with timestamps for requested edits. Often, my Pro Tools timestamps are off from those of the files I'm delivering to clients. I created this script help resolve this and make the edit timestamps match my session timestamps.

### In use
Simply run `./bin/run` and then follow the prompts. The script will take a column of timestamps (from a spreadsheet, for example) and an offset, then output a new column of timestamps with the offset included.
