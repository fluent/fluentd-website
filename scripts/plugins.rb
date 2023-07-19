require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'
require 'json'
require 'net/https'
require 'cgi'
require 'erb'
require 'yaml'

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

    gemlist = cmdout.scan(/^fluent-plugin-[^\s]+/)
    plugins = []
    http = Net::HTTP.new("rubygems.org", 443)
    http.use_ssl = true
    http.start do
      gemlist.each_with_index do |gemname, index|
        begin
          res = http.get("/api/v1/gems/#{e gemname}.json")
          puts "fetch (#{index+1}/#{gemlist.size}) /api/v1/gems/#{e gemname}.json" if ENV["DEBUG"]
          plugins << JSON.parse(res.body)
        rescue => e
          puts "failed to get plugin info. Skip #{gemname} plugin. #{e.inspect}"
        end
      end
    end

    plugins = plugins.sort_by { |pl| -pl['downloads'] }

    # Mark obsolete plugins
    plugins.each { |p|
      if OBSOLETE_PLUGINS.key?(p["name"])
        p["obsolete"] = true
        p["note"] = OBSOLETE_PLUGINS[p["name"]]
      end
   }

    # shrink minimum information
    plugins = plugins.map { |p|
      {
        obsolete: p["obsolete"],
        note: p["note"],
        name: p["name"],
        info: p["info"],
        authors: p["authors"],
        version: p["version"],
        downloads: p["downloads"]
      }
    }

    File.open(File.join(__dir__, "plugins.json"), "w") do |file|
      file.write(JSON.pretty_generate(plugins))
    end
  end

  OBSOLETE_PLUGINS = YAML.load_file(File.expand_path(File.join(__dir__, 'obsolete-plugins.yml')))
end

Plugins.update
