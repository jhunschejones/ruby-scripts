# Parse JPDB Stats

### Overview
There are already tools in place for gathering and creating daily study time stats for jpdb.io. This set of scripts simply cobbles those tools together to speed up the process of getting my daily study time for a specific date.

### Usage
The `./bin/run` coordinates the three pieces of this tool, downloading the `reviews.json` from jpdb.io, using it to generate stats from https://github.com/bijak/jpdb_stats, then parsing the stats out to some simple command line output showing the total study minutes per day.

NOTE: You will need the 1Password CLI installed and configured for the scripts to work out of the box, as it is used in `./bin/download-jpdb-reviews`. If you wish to use another tool to safely read out your username and password you may modifiy this file accordingly.
