require 'singleton'
require 'yaml'

module Pocketbeuter
  CONFIG_NAME = '.pocketbeuterrc'
  class ConfigFile
    include Singleton
    attr_reader :path

    def initialize
      @path = File.join(File.expand_path('~'), CONFIG_NAME)
      @config = load_config
    end

    def path=(path)
      @path = path
      @config = load_config
      @path
    end

    def [](account)
      @config['accounts'][account]
    end

    def load_config
      require 'yaml'
      YAML.load_file(@path)
    rescue Errno::ENOENT
      default_config
    end

    def default_config
      {'accounts' => {}}
    end
  end
end
