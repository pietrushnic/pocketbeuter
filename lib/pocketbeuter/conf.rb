require 'pocketbeuter/get_access_token_and_username'

module Conf
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
    load_config
    GetAccessToken.get_access_token_and_username
    save_config
  end
  def default_config
    config[:dir] = File.expand_path('~/.pocketbeuter')
    config[:file] = config[:dir] + '/config'
    config[:cache] = config[:dir] + '/cache'
  end
  def load_config
    default_config
    if File.exists?(config[:file])
      @config = YAML.load_file(config[:file])
    else
      File.open(config[:file], mode: 'w', perm: 0600).close
    end
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
  extend Conf
end
