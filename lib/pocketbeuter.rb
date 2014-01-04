require "pocketbeuter/version"
require "net/http"
require "uri"
require "launchy"
require "pocketbeuter/conf"
require "pocketbeuter/pocket"
require "pocketbeuter/configfile"
require "fileutils"
require "yaml"
require "thor"

module Pocketbeuter
  class Runner < Thor
    package_name "Pocketbeuter"

    desc "init", "initialize configuration and authorize Pocket app"
    def init
      Conf.init
    end
    desc "all", "get all Pocket articles"
    def all
      Conf.load_config
      unless Conf.config[:access_token]
        Conf.init
      end
      Pocket.all
    end
    desc "open ARTICLE_ID", "open Pocket article in browser"
    def open(id)
      Conf.load_config
      unless Conf.config[:access_token]
        Conf.init
      end
      Pocket.open(id)
    end
  end
end
