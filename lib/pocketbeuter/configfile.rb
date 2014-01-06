require 'singleton'
require 'yaml'

module Pocketbeuter
  class ConfigFile
    CONFIG_NAME = '.pocketbeuterrc'
    include Singleton
    attr_reader :path

    def initialize
      @path = File.join(File.expand_path('~'), CONFIG_NAME)
      @config = load_config
      @consumer_key = nil
      @redirect_uri = nil
    end

    def [](account)
      accounts[account]
    end

    def []=(subsec, sec)
      @config[subsec] ||= {}
      @config[subsec].merge!(sec)
      save_config
    end

    def accounts
      @config['accounts']
    end

    def consumer_key
      accounts[default_account]['consumer_key']
    end

    def consumer_key=(key)
      @config['accounts'][default_account]['consumer_key'] = key
    end

    def redirect_uri
      accounts[default_account]['redirect_uri']
    end

    def redirect_uri=(uri)
      @config['accounts'][default_account]['redirect_uri'] = uri
    end

    def get_token(name)
      accounts[name]['access_token']
    end

    def set_token(name, token)
      @config['accounts'][name]['access_token'] = token
      save_config
      load_config
    end

    def get_code(name)
      accounts[name]['request_token']
    end

    def set_code(name, code)
      @config['accounts'][name]['request_token'] = code
      save_config
      load_config
    end

    def path=(path)
      @path = path
      @config = load_config
      @path
    end

    def load_config
      require 'yaml'
      YAML.load_file(@path)
    rescue Errno::ENOENT
      default_config
    end

    def save_config
      require 'yaml'
      File.open(@path, File::RDWR | File::TRUNC | File::CREAT, 0600) do |f|
        f.write @config.to_yaml
      end
    end

    def default_config
      { 'options' => { 'default_account' => ENV['USER']}, 'accounts' => {}}
    end

    def default_account
      begin
        @config['options']['default_account']
      rescue
        if accounts.count > 0
          self.set_default_account =  accounts.first[0]
        else
          self.set_default_account = ENV['USER']
        end
        @config['options']['default_account']
      end
    end

    def set_default_account=(name)
      @config['options'] ||= {}
      @config['options']['default_account'] = name
      save_config
      load_config
    end

    def reset
      send(:initialize)
    end

    def empty?
      @config == default_config
    end
  end
end
