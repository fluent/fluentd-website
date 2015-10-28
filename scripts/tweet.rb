require 'twitter'
require 'nokogiri'
require 'open-uri'

twitter_credentials = {
  api_key: ENV['TW_API_KEY'],
  api_secret: ENV['TW_SECRET_KEY'],
  access_token: ENV['TW_ACCESS_TOKEN'],
  access_secret: ENV['TW_ACCESS_SECRET']
}

begin
  # extracting sitemapped URLs...
  sitemap_url = "http://www.fluentd.org/sitemap.xml"
  sitemap_xml = Nokogiri::XML(open(sitemap_url))
  urls = sitemap_xml.css("url loc").map { |x|
    x.text
  }.select { |x| x !~ /blog/ }

  # Randomly pick one
  # TODO: weight this based on priority
  urls.shuffle!
  url_to_tweet = urls.first

  # Formatting
  url_to_tweet
  title = Nokogiri::HTML(open(url_to_tweet)).css("title").text
  title.gsub!(/\s*\| Fluentd.*$/, "")
  tweet_body = "On our website: \"#{title}\" #{url_to_tweet}"

  # client
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = twitter_credentials[:api_key]
    config.consumer_secret     = twitter_credentials[:api_secret]
    config.access_token        = twitter_credentials[:access_token]
    config.access_token_secret = twitter_credentials[:access_secret]
  end

  # ready. tweet.
  client.update(tweet_body)

rescue Exception => e
  $stderr.puts e.backtrace
end
