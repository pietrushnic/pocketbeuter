module Pocketbeuter
  module GetAccessToken
    def get_request_token
      uri = URI.parse(OAUTH_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data("consumer_key" => Pocketbeuter.config[:consumer_key], "redirect_uri" => Pocketbeuter.config[:redirect_uri])
      http.use_ssl = true
      res = http.request(request)
      Pocketbeuter.config[:request_token] = URI.decode_www_form(res.body).first[1]
    end
    def get_access_token_and_username
      get_request_token
      auth_url = AUTH_URL + "?request_token=#{Pocketbeuter.config[:request_token]}&redirect_uri=#{Pocketbeuter.config[:redirect_uri]}"
      Launchy.open(auth_url)
      puts "Go to: #{auth_url}\nPress any key after authorization ..."
      STDIN.getc
      uri = URI.parse(OAUTH_AUTH_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data("consumer_key" => Pocketbeuter.config[:consumer_key], "code" => Pocketbeuter.config[:request_token])
      http.use_ssl = true
      res = http.request(request)
      Pocketbeuter.config[:access_token] = URI.decode_www_form(res.body)[0][1]
      Pocketbeuter.config[:username] = URI.decode_www_form(res.body)[1][1]
    end
    extend GetAccessToken
  end
end
