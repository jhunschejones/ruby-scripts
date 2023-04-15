# pCloud Folder Sync

### Overview
This script will allow users to specify a pCloud folder and a local directory that they want to stay in sync. The script will then diff the files in each and return a list of files that are in one but not the other. Future features may include the ability to upload and download missing files automatically from within the script.

### Using the script
The main script entry point will be with `./bin/run`. Make sure to set `PCLOUD_FOLDER_PATH` and `PCLOUD_ACCESS_TOKEN` env vars first, or export them in `./tmp/.env`.
