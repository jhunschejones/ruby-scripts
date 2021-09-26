# Example API Interactions

Use [the official pCloud API docs](https://docs.pcloud.com/) to find more details about all available actions.

### Raw API Examples
The following are some examples of using a Ruby HTTP client to make requests directly to the pCloud API

A full, authenticated request against the raw pCloud API might look like:
```ruby
list_of_folders = HTTParty.get(
  "https://api.pcloud.com/listfolder?path=#{URI.encode_www_form_component('/01 Docs')}",
  headers: { "Authorization" => "Bearer #{ACCESS_TOKEN}" }
)
```
And the same request using the helper method above looks like:
```ruby
Pcloud::Api.execute("listfolder", query: { path: "/01 Docs" })
```

To safely use a method that requires login, request a digest to sign the
password like this:
```ruby
print "username > "
username = $stdin.gets.chomp
print "password > "
password = $stdin.gets.chomp

# NOTE: Digests are only valid for 30 seconds
digest = JSON.parse(HTTParty.get("https://api.pcloud.com/getdigest").body)["digest"]
password_digest = Digest::SHA1.hexdigest(password + Digest::SHA1.hexdigest(username.downcase) + digest)

# NOTE: without the ACCESS_TOKEN from the server, this method requires MFA to
#       be completed
token_list = HTTParty.get(
  "https://api.pcloud.com/listtokens?username=#{URI.encode_www_form_component(username)}&digest=#{digest}&passworddigest=#{password_digest}",
  headers: { "Authorization" => "Bearer #{ACCESS_TOKEN}" }
)
```

### Wrapper Library Examples
The following are examples using some of the wrapper library methods included in this project.

Create a folder at a given path if one does not already exist:
```ruby
Pcloud::Folder.create_if_not_exists(path: "/api_test")
```

Upload a local file:
```ruby
uploaded_file = Pcloud::File.upload(
  path: "/api_test",
  filename: "IMG_3298.mp4",
  file: File.open("/Users/joshua/Downloads/IMG_3298.mp4")
)
```

Or find an existing file by path:
```ruby
found_file = Pcloud::File.find_by(path: "/api_test/IMG_3298.mp4")
```

Get the download url for a file:
```ruby
uploaded_file.download_url
```

Download a file to your local filesystem:
```ruby
uploaded_file.download_to(local_file_path: "IMG_3298.mp4")
```

Delete a file:
```ruby
uploaded_file.delete
```
