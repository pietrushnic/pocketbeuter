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
    end

    def [](node)
      @config[node]
    end

    def []=(subsec, sec)
      @config[subsec] ||= {}
      @config[subsec].merge!(sec)
      save_config
    end

    def account
      @config['account']
    end

    def account=(value)
      @config['account'] ||= value.keys[0]
      @config['account'][value.keys[0]] = value[value.keys[0]]
    end

    def account_name
      @config['account'].keys[0]
    end

    def account_name=(name)
      @config['account'][name] = {}
    end

    def consumer_key
      @config['account'][account_name]['consumer_key']
    end

    def consumer_key=(key)
      @config['account'][account_name] ||= 'consumer_key'
      @config['account'][account_name]['consumer_key'] = key
    end

    def redirect_uri
      @config['account'][account_name]['redirect_uri']
    end

    def redirect_uri=(uri)
      @config['account'][account_name] ||= 'redirect_uri'
      @config['account'][account_name]['redirect_uri'] = uri
    end

    def access_token
      @config['account'][account_name]['access_token']
    end

    def access_token=(token)
      @config['account'][account_name] ||= 'access_token'
      @config['account'][account_name]['access_token'] = token
    end

    def username
      @config['account'][account_name]['username']
    end

    def username=(name)
      @config['account'][account_name] ||= 'username'
      @config['account'][account_name]['username'] = name
    end

    def code
      @config['account'][account_name]['code']
    end

    def code=(token)
      @config['account'][account_name] ||= 'code'
      @config['account'][account_name]['code'] = token
    end

    def path=(path)
      @path = path
      @config = load_config
      @path
    end

    def load_config
      require 'yaml'
      if YAML.load_file(@path)
        YAML.load_file(@path)
      else
        default_config
      end
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
      { 'options' => {}, 'account' => {}}
    end

    def reset
      send(:initialize)
    end

    def empty?
      @config == default_config
    end
  end
end
