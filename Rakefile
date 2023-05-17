require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra/asset_pipeline/task'
require_relative './app'
Sinatra::AssetPipeline::Task.define! Sinatra::Application

task :server do
  exec 'ruby app.rb -p 9395'
end
def which(command)
  ENV['PATH'].
    split(':').
    map  { |p| "#{p}/#{command}" }.
    find { |p| File.executable?(p) }
end
task :start => :server
