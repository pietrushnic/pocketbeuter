require 'pocketbeuter/conf'
require "net/http"
require "json"
require "colorize"

module Pocket
  def all
    uri = URI.parse(Conf::GET_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data("consumer_key" => Conf.config[:consumer_key],
                          "state" => "all",
                          "access_token" => Conf.config[:access_token])
    http.use_ssl = true
    res = http.request(request)
    json = JSON.parse(res.body)
    puts json['status']
    puts json['complete']
    json['list'].each do |a|
      Hash[*a].each do |k,v|
        # {"item_id"=>"4158604",
        # "resolved_id"=>"4158604",
        # "given_url"=>"http://ds9a.nl/amazing-dna/",
        # "given_title"=>"DNA seen through the eyes of a coder",
        # "favorite"=>"0",
        # "status"=>"0",
        # "time_added"=>"1340118098",
        # "time_updated"=>"1340118101",
        # "time_read"=>"0",
        # "time_favorited"=>"0",
        # "sort_id"=>498,
        # "resolved_title"=>"DNA seen through the eyes of a coder",
        # "resolved_url"=>"http://ds9a.nl/amazing-dna/",
        # "excerpt"=>"This is just some rambling by a computer programmer about DNA. I'm not a molecular geneticist. If you spot the inevitable mistakes, please mail me (bert hubert) at ahu@ds9a.nl.  I'm not trying to force my view unto the DNA - each observation here is quite 'uncramped'.",
        # "is_article"=>"0",
        # "is_index"=>"0",
        # "has_video"=>"0",
        # "has_image"=>"1",
        # "word_count"=>"4486"}
        puts '['.blue + "%9s".white % v['item_id'] + ']'.blue + ' : ' + '"'.red + v['given_title'].cyan + '"'.red + " - " + v['given_url'].yellow
      end
    end

    File.open(Conf.config[:cache], 'w') do |f|
      f.write(JSON.dump(json))
      f.close
    end
  end
  def open(id)
    json = []
    if File.exists?(Conf.config[:cache])
      File.open(Conf.config[:cache], 'r') do |f|
        json = JSON.load(f.read)
      end
    end
    json['list'].each do |a|
      Hash[*a].each do |k,v|
        if v['item_id'] == id
          Launchy.open(v['given_url'])
        end
      end
    end
  end
  extend Pocket
end
