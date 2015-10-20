require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'
require 'json'
require 'net/http'
require 'cgi'
require 'erb'
require 'redis'

def e(s)
  CGI.escape(s.to_s)
end

class Plugins
  def self.update

    rpipe, wpipe = IO.pipe
    pid = Process.fork do
      rpipe.close
      $stdout.reopen wpipe
      begin
        Gem::GemRunner.new.run %w[search -r fluent-plugin]
      rescue Gem::SystemExitException => e
        exit e.exit_code
      end
      exit 0
    end
    wpipe.close
    cmdout = rpipe.read
    Process.waitpid2(pid)
    ecode = $?.to_i
    if ecode != 0
      exit ecode
    end

    gemlist = cmdout.scan(/fluent-plugin-[^\s]+/)
    plugins = []
    http = Net::HTTP.new("rubygems.org", 80)
    http.start do
      gemlist.each do |gemname|
        res = http.get("/api/v1/gems/#{e gemname}.json")
        js = JSON.parse(res.body)
        plugins << JSON.parse(res.body)
      end
    end

    plugins = plugins.sort_by { |pl| -pl['downloads'] }
	
    # Mark obsolete plugins
    plugins.each { |p|
      if OBSOLETE_PLUGINS.include?(p["name"])
        p["obsolete"] = true
      end
    }

    ENV["REDISTOGO_URL"] ||= 'redis://localhost:6379' # development
    redis_uri = URI.parse(ENV["REDISTOGO_URL"])
    redis = Redis.new(:host => redis_uri.host, :port => redis_uri.port, :password => redis_uri.password)
    redis.set("plugins", plugins.to_json)
  end

  OBSOLETE_PLUGINS = [
    'fluent-plugin-librato-metrics',
    'fluent-plugin-tail-ex',
    'fluent-plugin-tail-lite',
    'fluent-plugin-tail-multiline',
    'fluent-plugin-tail-asis',
    'fluent-plugin-hostname'
  ]
end

Plugins.update
