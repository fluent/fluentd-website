#require 'twitter'
require 'nokogiri'
require 'open-uri'

twitter_credentials = {
  api_key: ENV['TW_API_KEY'],
  api_secret: ENV['TW_SECRET_KEY'],
  access_token: ENV['TW_ACCESS_TOKEN'],
  access_secret: ENV['TW_ACCESS_SECRET']
}

if Time.now.wday.even?
  exit
end

begin
  # extracting sitemapped URLs...
  sitemap_url = "http://www.fluentd.org/sitemap.xml"
  sitemap_xml = Nokogiri::XML(open(sitemap_url))
  urls = sitemap_xml.css("url loc").map { |x|
    x.text
  }.select { |x| x !~ /blog|newsletter|events|rss|scribe|flume/ }

  # Some notable 3rd party stuff
  urls << 'https://docs.docker.com/config/containers/logging/fluentd/' # Docker
  urls << 'http://forums.juniper.net/t5/Analytics/Open-Source-Universal-Telemetry-Collector-for-Junos/ba-p/288677' # Juniper Networks
  urls << 'https://blog.minio.io/iot-data-storage-and-analysis-with-fluentd-minio-and-spark-26f183381183'
  urls << 'https://aws.amazon.com/blogs/aws/all-your-data-fluentd/'
  urls << 'http://thenewstack.io/fluentd-offers-comprehensive-log-collection-cloud-microservices-world/'
  urls << 'https://thenewstack.io/fluentds-role-as-a-data-collector-in-todays-cloud-native-world/'
  urls << 'https://aws.amazon.com/blogs/compute/building-a-scalable-log-solution-aggregator-with-aws-fargate-fluentd-and-amazon-kinesis-data-firehose/'
  urls << 'https://medium.com/redbox-techblog/building-an-open-data-platform-logging-with-fluentd-and-elasticsearch-4582de868398'
  urls << 'https://blog.newrelic.com/engineering/best-practices-for-log-forwarding/'

  # Randomly pick one
  # TODO: weight this based on priority
  urls.shuffle!
  url_to_tweet = urls.first

  # Formatting
  title = Nokogiri::HTML(open(url_to_tweet)).css("title").text
  title.gsub!(/\s*\| Fluentd.*$/, "")
  tweet_body = "\"#{title.strip}\" #{url_to_tweet}"

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
