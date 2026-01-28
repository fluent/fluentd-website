require 'logger'
require 'open-uri'
require 'optparse'
require 'tempfile'
require 'fileutils'

%w(nokogiri pastel).each do |gem|
  begin
    require "#{gem}"
  rescue LoadError => e
    puts "ERROR: missing #{gem}, gem install #{gem}"
    exit 1
  end
end

#
# Compare current official heroku contents and deheroku contents
#
# Usage:
#  ruby deheroku-checker.rb --deheroku-site https://[OWNER].github.io/fluentd-website
#

class DeherokuChecker
  def initialize(options={})
    @options = {
      deheroku_site: 'https://example.github.com/fluentd-website',
      output_dir: 'deheroku-checked',
      log_level: Logger::INFO,
      sitexml: :old,
      diff_threshold: 1,
      verify_reverse: false
    }.merge!(options)
    @pass_count = 0
    @fail_count = 0
    @skip_count = 0
    @skip_list = [
      '/minimal_layout',
      '/rss',
      '/blog_archive',
      '/newsletter_signup',
      '/download_fluent_package',
      '/download_calyptia_fluentd',
      '/related_projects',
    ]
    @output_dir = @options[:output_dir]
    @diff_threshold = @options[:diff_threshold]
    @verify_reverse = @options[:verify_reverse]
    @logger = Logger.new(STDOUT)
    @logger.level = @options[:log_level]
    @pastel = Pastel.new(enabled: true)
    
    FileUtils.mkdir_p(@output_dir)
    site = URI.parse(@options[:deheroku_site])
    @http_prefix = site.path
  end

  def sitemap_urls(url)
    xml = URI.open(url).read
    doc = Nokogiri::XML(xml)
    doc.remove_namespaces!
    uri = URI.parse(@options[:deheroku_site])
    doc.xpath('//url/loc').collect do |url|
      if @verify_reverse
        url.text.sub(uri.path, '/')
      else
        url.text
      end
    end
  end

  def save_html_as(url, dir, label)
    FileUtils.mkdir_p(dir)
    content = URI.open(url).read
    path = File.join(dir, URI.parse(url).path.gsub('/', '_') + '.raw.html')
    File.open(path, 'w+') { |f| f.write(content) }
    path
  end

  def filter_script_html(path, options={})
    label = options[:label]

    html = File.read(path)
    doc = Nokogiri::HTML5(html)

    # remove newly introduced <script>
    scripts = [
      'jquery-1.10.2.min.js',
      'jquery-migrate-1.2.1.min.js',
      'bootstrap/bootstrap.min.js',
      'flexslider/jquery.flexslider-min.js',
      'parallax-slider/modernizr.js',
      'parallax-slider/jquery.cslider.js',
      'hover-dropdown.min.js',
      'back-to-top.js',
      'app.js',
      'pages/index.js'
    ]
    scripts.each do |script|
      @logger.debug("[#{label}] omit <#{script}> from <#{path}>")
      doc.css(%Q(script[src="#{@http_prefix}javascripts/#{script}"])).remove
    end

    stylesheets = [
      'bootstrap/bootstrap.min.css',
      'font-awesome/font-awesome.css',
      'flexslider/flexslider.css',
      'bootstrap/bootstrap.min.css',
      'parallax-slider/parallax-slider.css',
      'app.css',
      'style.css',
      'headers/header1.css',
      'responsive.css',
      'pages/page_clients.css',
      'themes/default.css',
      'newsletter.css'
    ]
    stylesheets.each do |css|
      @logger.debug("[#{label}] omit <#{css}> from <#{path}>")
      doc.css(%Q(link[href="#{@http_prefix}stylesheets/#{css}"])).remove
    end

    table = {
      "/assets/application-6337697122cbccaa1069237ae24fe1e3d18dea244a15eb08170a4e33faf0f92a.js" =>
      "#{@http_prefix}javascripts/application.js",
      "/assets/application-86e13619371e815be96ae0b441eb3b570314624f182ab1b15553ee38f353cec0.css" =>
      "#{@http_prefix}stylesheets/application.css",
      "/assets/respond-81fb9e7a70c0940db38c1c7baf658a7ed589efd91defa648aeee277847ec2175.js" =>
      "#{@http_prefix}javascripts/respond.js",
      "/assets/newsletter-0884a3dee4d26a6692eab030d631c43c044bea7a56b1991da2f814036029ce74.css" =>
      "#{@http_prefix}stylesheets/newsletter.css",
      "/assets/pages/lunr.min-999fe100bf0143338db7a9807eae14581580205343d161602cdda4ad738f172e.js" =>
      "#{@http_prefix}javascripts/pages/lunr.min.js"
    }
    doc.css('script[src]').each do |script|
      if table.keys.include?(script['src'])
        new_src = table[script['src']]
        @logger.debug("[#{label}] <#{script['src']}> should be <#{new_src}>")
        script['src'] = script['src'].sub(script['src'], new_src)
      end
    end
    doc.css('link[href]').each do |link|
      if table.keys.include?(link['href'])
        new_src = table[link['href']]
        @logger.debug("[#{label}] <#{link['href']}> should be <#{new_src}>")
        link['href'] = link['href'].sub(link['href'], new_src)
      end
    end
    if label == 'old'
      # omit application.css, because it is not used in deheroku
      @logger.debug("[#{label}] remove unused <#{@http_prefix}stylesheets/application.css>")
      doc.css(%Q(link[href="#{@http_prefix}stylesheets/application.css"])).remove
    end
    doc.css(%Q(link[href="#{@http_prefix}stylesheets/newsletter.css"])).remove

    # omit all coment
    doc.xpath('//comment()').remove

    output_path = File.join(File.dirname(path), "#{File.basename(path, '.raw.html')}.filter.html")
    File.write(output_path,
               doc.to_html(save_with: Nokogiri::XML::Node::SaveOptions::DEFAULT_HTML))
    @logger.debug("[#{label}] omit script and save it as #{output_path}")

    # omit empty lines
    html = File.read(output_path)
    html.gsub!(/^\s*\n/, '')

    # convert plugins.html
    @logger.debug("[#{label}] convert var plugins in plugins.html: <#{output_path}")
    html.gsub!(/img src='\/images\//, "img src='#{@http_prefix}images\/")
    html.gsub!(/href='\/faqs\#certified/, "href='#{@http_prefix}faqs\#certified")

    File.write(output_path, html)

    output_path
  end

  def translate_html(path, options={})
    # translate with http_prefix
    label = options[:label]
    @logger.debug("[#{label}] try to translate <#{path}>")

    html = File.read(path)
    doc = Nokogiri::HTML5(html)

    patterns = [
      "/favicon.ico",
      "/adtech_application_logging",
      "/architecture",
      "/blog",
      "/centralized_application_logging",
      "/community",
      "/contributing",
      "/dataoutputs",
      "/datasources",
      "/download",
      "/enterprise_services",
      "/faqs",
      "/gaming_application_logging",
      "/guides",
      "/highlight",
      "/images",
      "/newsletter",
      "/plugins",
      "/related-projects",
      "/slides",
      "/testimonials",
      "/treasuredata",
      "/videos",
      "/why",
    ]
    { 'a[href]' => 'href',
      'img[src]' => 'src',
      'link[href]' => 'href',
      'script[src]' => 'src',
      'img[srcset]' => 'srcset'}.each do |target, attr|
      doc.css(target).each do |element|
        source = element[attr]
        #@logger.debug("source: <#{source}>")
        patterns.each do |pattern|
          if element[attr] == '/'
            element[attr] = @http_prefix
          else
            if element[attr].start_with?(pattern)
              if attr == 'srcset'
                element[attr] = element[attr].gsub(/\/images/, @http_prefix + 'images')
              else
                element[attr] = @http_prefix + element[attr][1..]
              end
            end
          end
        end
        if source != element[attr]
          @logger.debug("translate #{target} <#{source}> => <#{element[attr]}>")
        end
      end
    end

    # omit expanded application.js
    # old.gsub!(%r{<script\b[^>]*>\s*[\s\S]*?\(?window\.[\s\S]*?</script>\s*}i, '')

    # make compatible with javascript_include_tag
    #old.gsub!(/ type="text\/javascript"><\/script>/, "></script>")
    # fix srcset
    #old.gsub!(/, \/images/, ", #{@http_prefix}/images")

    output_path = File.join(File.dirname(path), "#{File.basename(path, '.filter.html')}.trans.html")
    File.write(output_path,
               doc.to_html(save_with: Nokogiri::XML::Node::SaveOptions::DEFAULT_HTML))
    @logger.debug("[#{label}] translate tag and save it as #{output_path}")
    output_path
  end

  def git_diff(old_path, new_path, options={})
    label = options[:label]
    path = File.join(@output_dir, File.basename(old_path, '.trans.html') + '.diff')
    FileUtils.mkdir_p(@output_dir)
    File.open(path, 'w+') do |file|
      @logger.debug("[#{label}] diff <#{old_path}> and <#{new_path}>")
      IO.popen(["git", "diff",  "--ignore-blank-lines", "--no-index", "--color=always",
                "--unified", "-w",
                old_path, new_path]) do |io|
        file.write(io.read)
      end
    end
    if File.stat(path).size == 0
      @logger.debug("[#{label}] no diff output, unlink #{path}")
      File.unlink(path)
      {log: path, size: 0}
    else
      @logger.debug("[#{label}] save diff output as #{path}")
      {log: path, size: File.stat(path).size}
    end
  end

  def info(label, message)
    @logger.info("[#{@pastel.green.on_black(label)}] #{message}")
  end

  def debug(label, message)
    @logger.debug("[#{@pastel.magenta.on_black(label)}] #{message}")
  end

  def error(label, message)
    @logger.error("[#{@pastel.red.on_black(label)}] #{message}")
  end

  def warning(label, message)
    @logger.warn("[#{@pastel.bright_yellow.on_black(label)}] #{message}")
  end

  def red(message)
    @pastel.red.on_black(message)
  end

  def green(message)
    @pastel.green.on_black(message)
  end

  def yellow(message)
    @pastel.bright_yellow.on_black(message)
  end

  def magenta(message)
    @pastel.magenta.on_black(message)
  end

  def gen_summary_markdown(paths)
    diff_summary_path = File.join(@output_dir, 'summary.md')
    @logger.info("diff summay was saved as <#{diff_summary_path}>")
    File.open(diff_summary_path, 'w+') do |f|
      list = if paths.empty?
               "No diff detected"
             else
               "* " + paths.join("\n* ")
             end
      f.puts <<~EOS
\# Summary of DeHeroku

\#\# DeHeroku Stats


* PASS: #{@pass_count}
* SKIP: #{@skip_count}
* FAIL: #{@fail_count}

* TOTAL: #{@pass_count + @skip_count + @fail_count}

\#\# DeHeroku failed contents

#{list}
EOS
    end
  end

  def convert_migration_url(url)
    url.sub("https://www.fluentd.org/", @options[:deheroku_site])
  end

  def compare_contents(sitemap_url, old_label, new_label)
    @logger.debug("sitemap url <#{sitemap_url}>")
    targets = sitemap_urls(sitemap_url)
    
    if @options[:uri_path]
      targets = ['https://www.fluentd.org' + @options[:uri_path]]
    end

    @logger.debug("processing <#{targets.size}> urls")
    diff_paths = []
    blog_entries = targets.count { |url| url.include?("/blog/") }
    @logger.debug("contains #{blog_entries} blog entries")

    targets.each do |url|
      next if url == 'https://www.fluentd.org/'
      next if url == 'https://www.fluentd.org/fluentd-website'
      if @options[:skip_pattern]
        pattern = Regexp.new(@options[:skip_pattern])
        if url.match?(pattern)
          @logger.debug("skip: #{url}")
          @skip_count += 1
          next
        end
      end
      target = convert_migration_url(url)
      @logger.debug("[old] #{url}")
      @logger.debug("[new] #{target}")
      uri = URI.parse(url)
      if @skip_list.include?(uri.path)
        @logger.info("[#{magenta('SKIP')}] deprecated URI: <#{url}>")
        @skip_count += 1
        next
      end
      begin
        old_path = save_html_as(url, File.join(@output_dir, old_label), 'old')
        new_path = save_html_as(target, File.join(@output_dir, new_label), 'new')

        deheroku_uri = URI.parse(@options[:deheroku_site])
        @logger.debug("prefix: #{deheroku_uri.path}")
        # e.g. out/old/_why.raw.html
        #      out/new/_fluentd_website_why.raw.html

        old_path = filter_script_html(old_path, { label: 'old' })
        new_path = filter_script_html(new_path, { label: 'new' })
        old_path = translate_html(old_path, { label: 'old' })
        if target.include?("/blog/")
          # translate /blog/ article because it does not support md.erb.
          new_path = translate_html(new_path, { label: 'new' })
        end
        
        stat = git_diff(old_path, new_path, { label: 'diff' })
        if stat[:size] < @diff_threshold.to_i
          @pass_count += 1
          info('PASS', "#{target} #{stat[:log]}")
        else
          @fail_count += 1
          diff_paths << stat[:log]
          error('DIFF', "#{red(target)} #{stat[:log]} (#{stat[:size]} > #{@diff_threshold})")
        end
      rescue OpenURI::HTTPError => e
        @fail_count += 1
        error('ERROR', "#{target} error: #{e.message}")
      rescue RuntimeError => e
        @fail_count += 1
        error('ERROR', "#{target} error: #{e.message}")
      end
    end
    @logger.info("TOTAL: #{@pass_count + @skip_count + @fail_count} PASS: #{green(@pass_count)} FAIL: #{red(@fail_count)} SKIP: #{magenta(@skip_count)}")
    gen_summary_markdown(diff_paths)
    @fail_count
  end

  def run
    if @verify_reverse 
      compare_contents('https://kenhys.github.io/fluentd-website/sitemap.xml', 'old_ng', 'new_ng')
    else
      compare_contents('https://www.fluentd.org/sitemap.xml', 'old', 'new')
    end
  end
end

options = {}
opt = OptionParser.new do |opts|
  opts.on('--deheroku-site SITE', 'Migration web site URL') do |v|
    options[:deheroku_site] = v
  end
  opts.on('--output-dir DIRECTORY', 'Output logging directory') do |v|
    options[:output_dir] = v
  end
  opts.on('--uri-path URI_PATH', 'Specify relative target URI path') do |v|
    options[:uri_path] = v
  end
  opts.on('--skip-pattern PATTERN', 'Specify skip pattern') do |v|
    options[:skip_pattern] = v
  end
  opts.on('--diff-threshold THRETHOLD', 'Specify diff size threshold') do |v|
    options[:diff_threshold] = v
  end
  opts.on('--verify-reverse', 'Verify with middleman sitemap.xml') do |v|
    options[:verify_reverse] = v
  end
  opts.on('--log-level LEVEL', 'Specify log level for debug') do |v|
    options[:log_level] = case v
                           when 'debug'
                             Logger::DEBUG
                           else
                             Logger::INFO
                           end
  end
end
opt.parse!(ARGV)

checker = DeherokuChecker.new(options)
exit(checker.run)
