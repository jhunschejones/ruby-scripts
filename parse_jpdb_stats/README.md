# Parse JPDB Stats

### Overview
This project holds a small set of scripts that help connect existing tools in order to provide my daily study minutes on jpdb.io.

Special thanks to `@bijak` for his help consulting on the logic for estimating the number of minutes spent reviewing per day 🫶🏻✨

### Usage
The `./bin/run` script coordinates all the moving parts of this tool, downloading the `reviews.json` from jpdb.io, transforming the data into a list total study minutes per day, then logging the script session out of jpdb.io.

NOTE: The script will attempt to use the 1Password CLI to safely gather credentials for the web request to jpdb.io made in `./bin/download-jpdb-reviews`. You may also chose to set the environment values for `JPDB_USERNAME` and `JPDB_PASSWORD` if you don't have 1Password or don't want to mess with configuring it's CLI, and the script will read those instead.
