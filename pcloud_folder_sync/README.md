# pCloud Folder Sync

### Overview
This script will allow users to specify a local directory that they want to stay up to date with a specific pCloud folder. The script will find new files in the pCloud folder that do not exist locally and then download them. I use this script to help keep a local backup of a specific documents directory in pCloud up to date.

Future features for the script may include the ability to choose whether to upload or delete files that are in the local directory but not in pCloud, or perhaps an interactive prompt for users to specify more behaviors.

### Using the script
The main script entry point will be with `./bin/run`. Make sure to set `PCLOUD_FOLDER_PATH`, `LOCAL_FOLDER_PATH`, and `PCLOUD_ACCESS_TOKEN` env vars first, or export them in `./tmp/.env`. To easily get a valid `LOCAL_FOLDER_PATH`, simply drag the folder into the terminal and copy that path into the env var value.
