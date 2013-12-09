require "pocketbeuter/version"
require "net/http"
require "uri"
require "launchy"
require "pocketbeuter/get_access_token_and_username"
require "fileutils"
require "yaml"

module Pocketbeuter
  ADD_URL = 'https://getpocket.com/v3/add'
  SEND_URL = 'https://getpocket.com/v3/send'
  GET_URL = 'https://getpocket.com/v3/get'
  OAUTH_URL = 'https://getpocket.com/v3/oauth/request'
  AUTH_URL = 'https://getpocket.com/auth/authorize'
  OAUTH_AUTH_URL = 'https://getpocket.com/v3/oauth/authorize'

  def config
    @config ||= {}
  end
  def init
    @config = YAML.load_file(File.expand_path('~/.pocketbeuter/config'))
    config[:dir] = File.expand_path('~/.pocketbeuter')
    config[:file] = config[:dir] + '/config'
    GetAccessToken.get_access_token_and_username
    save_config
  end
  def save_config
    unless File.exists?(config[:dir])
      FileUtils.mkdir_p(config[:dir])
    end

    if File.exists?(config[:file])
      File.open(config[:file], 'w') { |f| f.write(config.to_yaml) }
    else
      File.open(config[:file], mode: 'w', perm: 0600).close
    end
  end
  extend Pocketbeuter
end
