#!/usr/bin/bash

set -eu

export BUNDLE_GEMFILE=Gemfile.middleman
bundle install
bundle exec ruby ./scripts/symlink_middleman_source.rb

sed -i'' -e "s|^set :http_prefix, '/fluentd-website/'|#set :http_prefix, '/fluentd-website/'|" config.rb
sed -i'' -e "s|^#set :http_prefix, '/'|set :http_prefix, '/'|" config.rb
bundle exec middleman build --verbose

sed -i  "s|url(/assets/plugins/parallax-slider/img|img|g" build/stylesheets/parallax-slider/parallax-slider.css
