require 'rubygems'
require 'bundler'
Bundler.setup

desc 'Run local server'
task :server do
  exec 'bundle exec middleman server --verbose'
end
task :start => :server

desc 'Build local content'
task :build do
  exec './scripts/build_netlify.sh'
end

desc 'Update tags'
task :update_tags do
  exec 'ruby scripts/generate_tags.rb'
end
