require "pocketbeuter/version"
require "net/http"
require "uri"

module Pocketbeuter


  ADD_URL = 'https://getpocket.com/v3/add'
  SEND_URL = 'https://getpocket.com/v3/send'
  GET_URL = 'https://getpocket.com/v3/get'
  OAUTH_URL = 'https://getpocket.com/v3/oauth/request'

  class Runner
    def self.start
      uri = URI.parse("https://getpocket.com/v3/oauth/request")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data("consumer_key" => CONSUMER_KEY, "redirect_uri" => REDIRECT_URI)
      http.use_ssl = true
      res = http.request(request)
      puts res.body
    end
  end
end
