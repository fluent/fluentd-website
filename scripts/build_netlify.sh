#!/usr/bin/bash

set -eu

bundle install
bundle exec ruby ./scripts/symlink_middleman_source.rb

bundle exec middleman build --verbose

sed -i  "s|url(/assets/plugins/parallax-slider/img|img|g" build/stylesheets/parallax-slider/parallax-slider.css
