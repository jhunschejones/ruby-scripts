# pCloud API

### Overview:
Since pCloud does not currently offer a Ruby SDK, I created this script to help me better understand how to interact with the [pCloud API](https://docs.pcloud.com/) directly from Ruby. This includes actions that require completing the server-side OAuth 2.0 flow, manual user login, and more!

Run `./bin/console` to start playing with the code right away or check out some of the [example interactions](example_api_interactions.md).

NOTE: using the `./get_access_token.rb` script to set up OAuth will append your access token to a text file in `/tmp`. Make sure you do not accidentally check this file in or expose it anywhere by mistake!
