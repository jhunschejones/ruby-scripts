# Time Offset

### Overview
While editing/mixing podcasts I ask for client notes in a CSV format with timestamps for requested edits. Often, my Pro Tools timestamps are different from the exported files I deliver to clients. I created this script help resolve this issue by modifying a list of timestamps by a given offset so that my timestamps can match those of the requested edits.

### In use
Simply run `./bin/run` and then follow the prompts. The script will take a column of timestamps (from a spreadsheet, for example) and an offset, then output a new column of timestamps with the offset included.

_Example CLI session:_
```
Enter column of times in MM:SS format, separated by newlines:
> 1:23
1:55
2:15-2:25
Enter offset in MM:SS format:
> 0:21
01:44
02:16
02:36-02:46
```
