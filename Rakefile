require 'rubygems'
require 'bundler'
Bundler.setup

task :server do
  if which('shotgun')
    exec 'shotgun -O app.rb -p 9200 -o 0.0.0.0'
  else
    warn 'warn: shotgun not installed; reloading is disabled.'
      exec 'ruby -rubygems app.rb -p 9395'
  end
end
def which(command)
  ENV['PATH'].
    split(':').
    map  { |p| "#{p}/#{command}" }.
    find { |p| File.executable?(p) }
end
task :start => :server
