module Pcloud
  class Api
    class Error < StandardError; end
    US_API_BASE = "api.pcloud.com".freeze
    EU_API_BASE = "eapi.pcloud.com".freeze
    ACCESS_TOKEN = ::File.read(ACCESS_TOKEN_PATH).freeze
    TIMEOUT_SECONDS = 8.freeze

    class << self
      # NOTE: no need to URI.encode_www_form_component params when using the "query"
      #       argument in HTTParty, the library does it for you for free!
      # NOTE: HTTParty sets multipart: true automatically, which is required for file uploads
      def execute(method, query: {}, body: {})
        verb = ["uploadfile"].include?(method) ? :post : :get
        options = {
          headers: { "Authorization" => "Bearer #{ACCESS_TOKEN}" },
          timeout: TIMEOUT_SECONDS
        }
        options.merge!({ query: query }) unless query.empty?
        options.merge!({ body: body }) unless body.empty?
        response =
          show_method_progress do
            HTTParty.public_send(verb, "https://#{closest_server}/#{method}", options)
          end
        response = JSON.parse(response.body)
        raise Error.new(response["error"]) if response["error"]
        response
      end

      private

      def closest_server
        @@closest_server ||= begin
          HTTParty.get("https://#{US_API_BASE}/getapiserver")["api"].first
        end
      end

      def show_method_progress
        progress_thread = Thread.new do
          Thread.current[:has_entered_loop] = false
          sleep 2
          print "Sending request to pCloud.."
          loop do
            Thread.current[:has_entered_loop] = true
            sleep 1
            print "."
          end
        end
        return_value = yield
        # Move to the next line if we've already started printing dots on the current line
        puts "." if progress_thread.exit[:has_entered_loop]
        return_value
      end
    end
  end
end
