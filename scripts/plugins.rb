require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'
require 'json'
require 'net/https'
require 'cgi'
require 'erb'
require 'yaml'
require 'time'
require "optparse"
require 'open-uri'

def e(s)
  CGI.escape(s.to_s)
end

def parse_command_line
  options = {}
  parser = OptionParser.new
  parser.on("--force-update", "Force update for debugging.") do
    options[:force_update] = true
  end
  parser.parse!
  options
end

class Plugins
  def self.update(force_update: false)

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

    # shrink minimum information
    plugins = plugins.map { |p|
      {
        obsolete: p["obsolete"],
        note: p["note"],
        name: p["name"],
        info: p["info"],
        authors: p["authors"],
        version: p["version"],
        downloads: p["downloads"],
        homepage_uri: p["homepage_uri"],
        source_code_uri: p["source_code_uri"],
      }
    }

    previous_plugins = YAML.load_file(plugins_json).collect { |plugin| plugin["name"] }
    current_plugins = plugins.collect { |plugin| plugin[:name] }
    # When the number of plugin is changed, update it.
    deleted_plugins = previous_plugins - current_plugins
    added_plugins = current_plugins - previous_plugins
    if ENV["DEBUG"]
      puts "added: #{added_plugins}"
      puts "deleted: #{deleted_plugins}"
    end
    if force_update or need_update?(added_plugins, deleted_plugins)
      mark_obsolete(plugins)
      File.open(plugins_json, "w") do |file|
        file.write(JSON.pretty_generate(plugins))
      end
      write_commit_message(added_plugins, deleted_plugins)
    end
  end

  def self.need_update?(added_plugins, deleted_plugins)
    added_plugins.size > 0 or deleted_plugins.size > 0 or has_been_a_week?
  end

  def self.mark_obsolete(plugins)
    plugins.each { |p|
      if OBSOLETE_PLUGINS.key?(p[:name])
        p[:obsolete] = true
        p[:note] = OBSOLETE_PLUGINS[p[:name]]
        next
      end
      if p[:homepage_uri] and not p[:homepage_uri].empty?
        unless uri_alive?(p[:homepage_uri])
          p[:obsolete] = true
          p[:note] = "Can't access the homepage."
        end
      end
    }
  end

  def self.uri_alive?(uri)
    OpenURI.open_uri(uri, read_timeout: 5) { |f|
      status_code = f.status[0].to_i
      if status_code >= 400
        puts "#{uri} is dead: #{status_code}" if ENV["DEBUG"]
        return false
      end
    }
    true
  rescue => e
    puts "#{uri} error: #{e.inspect}" if ENV["DEBUG"]
    return false
  end

  def self.commit_message_file
    File.join(__dir__, "message.txt")
  end

  def self.plugins_json
    File.join(__dir__, "plugins.json")
  end

  def self.write_commit_message(added_plugins, deleted_plugins)
    File.open(commit_message_file, "w") do |file|
      messages = "Update plugins.json\n"
      added_messages = ""
      deleted_messages = ""
      if added_plugins.size > 0
        added_messages =<<~EOS

            added plugins:
              * #{added_plugins.join("\n  * ")}
          EOS
      end
      if deleted_plugins.size > 0
        deleted_messages =<<~EOS

            deleted plugins:
              * #{deleted_plugins.join("\n  * ")}
          EOS
      end
      file.write(messages + added_messages + deleted_messages)
    end
  end

  def self.has_been_a_week?
    last_modified = Time.parse(`git log -1 --pretty="format:%ci" #{plugins_json}`)
    duration = Time.now.to_i - last_modified.to_i
    seconds_in_a_week = 60 * 60 * 24 * 7
    duration > seconds_in_a_week
  end

  OBSOLETE_PLUGINS = YAML.load_file(File.expand_path(File.join(__dir__, 'obsolete-plugins.yml')))
end

Plugins.update(**parse_command_line)
