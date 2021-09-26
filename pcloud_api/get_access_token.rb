require_relative "./lib/module_loader"

puts "1. Register an app at https://docs.pcloud.com/my_apps/".cyan
puts "2. Enter the client id and secret for the app:".cyan
print "Client ID > "
CLIENT_ID = $stdin.gets.chomp.freeze
print "Client Secret > "
CLIENT_SECRET = $stdin.gets.chomp.freeze

puts "3. Navigate to this URL to start the code flow:".cyan
puts "https://my.pcloud.com/oauth2/authorize?client_id=#{CLIENT_ID}&response_type=code"
puts "4. After logging in, enter the code provided below:".cyan
print "> "

ACCESS_CODE = $stdin.gets.chomp.freeze

puts "5. Requesting access token from pCloud...".cyan

response = HTTParty.post(
  "https://#{Pcloud::Api::EU_API_BASE}/oauth2_token",
  query: { client_id: CLIENT_ID, client_secret: CLIENT_SECRET, code: ACCESS_CODE }
)

puts "6. Writing access token to #{ACCESS_TOKEN_PATH}...".cyan

File.write(ACCESS_TOKEN_PATH, JSON.parse(response.body)["access_token"], mode: "w+")

puts "Done!".green
