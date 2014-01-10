require 'launchy'
require 'thor'
require 'pocketbeuter/get_access_token_and_username'
require 'pocketbeuter/configfile'
require 'pocketbeuter/pocket'

module Pocketbeuter
  class CLI < Thor
    ADD_URL = 'https://getpocket.com/v3/add'
    SEND_URL = 'https://getpocket.com/v3/send'
    GET_URL = 'https://getpocket.com/v3/get'
    OAUTH_URL = 'https://getpocket.com/v3/oauth/request'
    AUTH_URL = 'https://getpocket.com/auth/authorize'
    OAUTH_AUTH_URL = 'https://getpocket.com/v3/oauth/authorize'
    POCKET_DEV = 'http://getpocket.com/developer/apps/new'
    check_unknown_options!
    class_option 'config', :aliases => '-c', :type => :string, :default => File.join(File.expand_path('~'), Pocketbeuter::ConfigFile::CONFIG_NAME), :desc => 'Path to config file', :banner => 'CONFIG'

    attr_reader :config
    def initialize(*)
      @config = Pocketbeuter::ConfigFile.instance
      super
    end

    desc 'createapp', 'create Pocket API application'
    def createapp
      say "Good day Sir/Madam before you can use pocketbeuter, you'll first"
      say "need to register your application. Please follow below steps:"
      say "    1. Log in into Pocket site."
      say "    2. Create an Application - complete required fields and click"
      say "       \"CREATE APPLICATION\" button."
      say "       NOTE: application must have unique name (I recommend: <login>/pocketbeuter),"
      say "             add application description and give Add, Modify and Retrieve permissions,"
      say "             select platform for your application (i.e. Desktop (other)), and accept"
      say "             license terms"
      ask " Press any key to open Pocket Create an Application form"
      say
      #Launchy.open(Pocketbeuter::CLI::POCKET_DEV)
      account_name = ask "Enter account name [#{ENV['USER']}]:"
      if account_name.empty?
        @config.account_name = ENV['USER']
      else
        @config.account_name = account_name
      end

      #TODO: handle empty consumer_key
      @config.consumer_key = ask 'Enter consumer key:'
      #TODO: handle empty redirect_uri
      redirect_uri = ask 'Enter redirect uri:'
      @config.redirect_uri = redirect_uri
    end

    desc 'authorize', 'request Pocket user authorization'
    def authorize
      @config.path = options['config'] if options['config']
      if @config.empty?
        uri = URI.parse(OAUTH_URL)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data("consumer_key" => @config.consumer_key, "redirect_uri" => @config.redirect_uri)
        http.use_ssl = true
        res = http.request(request)
        Conf.config[:request_token] = URI.decode_www_form(res.body).first[1]
        auth_url = AUTH_URL + "?request_token=#{Conf.config[:request_token]}&redirect_uri=#{Conf.config[:redirect_uri]}"
        Launchy.open(auth_url)
        puts "Go to: #{auth_url}\nPress any key after authorization ..."
        STDIN.getc
        uri = URI.parse(OAUTH_AUTH_URL)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data("consumer_key" => Conf.config[:consumer_key], "code" => Conf.config[:request_token])
        http.use_ssl = true
        res = http.request(request)
        Conf.config[:access_token] = URI.decode_www_form(res.body)[0][1]
        Conf.config[:username] = URI.decode_www_form(res.body)[1][1]
      end
    end
  end
end
