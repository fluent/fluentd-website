require 'bundler/setup'
require './app.rb'

# Compression
use Rack::Deflater

# Cache
# @see http://henrik.nyh.se/2012/07/sinatra-with-rack-cache-on-heroku/
# @see https://devcenter.heroku.com/articles/rack-cache-memcached-static-assets-rails31
# if memcache_servers = ENV["MEMCACHE_SERVERS"]
#   require "rack-cache"
#   require "dalli"
#   use Rack::Cache,
#     verbose: true,
#     metastore: "memcached://#{memcache_servers}",
#     entitystore: "memcached://#{memcache_servers}"
# end

run Sinatra::Application
