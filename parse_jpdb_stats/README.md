# Parse JPDB Stats

### Overview
There are already several tools in place for gathering and creating daily study time stats for jpdb.io. This set of scripts helps cobble these tools together to speed up the process of getting my daily study time on jpdb.io.

Special thanks to @bijak for his help building the logic for estimating number of minutes spent reviewing per day 🫶🏻✨

### Usage
The `./bin/run` script coordinates the moving parts of this tool, downloading the `reviews.json` from jpdb.io, transforming the stats to a total study minutes per day, then logging the script session out of jpdb.io.

NOTE: You will need the 1Password CLI installed and configured for the scripts to work out of the box, as it is used in `./bin/download-jpdb-reviews`. If you wish to use another tool to safely read out your username and password you may modify this file accordingly.
