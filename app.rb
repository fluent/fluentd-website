require 'sinatra'
require 'sinatra/asset_pipeline'
require 'json'
require 'time'
require 'yaml'
require 'redcarpet'
require 'slugify'

# Settings
set :app_file, __FILE__
set :static_cache_control, [:public, :max_age => 3600*24]

# NewRelic
configure :production do
  require 'newrelic_rpm'
end

# Static Assets
# @see https://github.com/kalasjocke/sinatra-asset-pipeline
set :root, __dir__
set :assets_precompile, %w(application.css application.js newsletter.css pages/lunr.min.js respond.js)
set :assets_paths, %w(assets/css assets/js assets/plugins)
set :assets_css_compressor, :sass
set :assets_js_compressor, :uglifier
Sinatra.register Sinatra::AssetPipeline

MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, fenced_code_blocks: true)

# TODO: should not hardcode this
TD_AGENT_VERSIONS = {
  :v1 => {
    linux: "1.1.21",
    gem_v10: "0.10.61",
    gem_v12: "0.12.43",
    gem_v14: "0.14.25",
    'gem_v1.0': '1.16.3'
  },
  :v2 => {
    linux: "2.5.0",
    mac: "2.3.5"
  },
  :v3 => {
    linux: "3.8.1",
    mac: "3.1.1",
    win: "3.8.1"
  },
  :v4 => {
    linux: "4.5.2",
    mac: "4.5.2",
    win: "4.5.2"
  },
  :bit => {
    linux: "1.6.9"
  }
}

FLUENT_PACKAGE_VERSIONS = {
  :v5 => {
    linux: "5.0.2",
    mac: "5.0.2",
    win: "5.0.2"
  },
  :v5_lts => {
    linux: "5.0.2",
    mac: "5.0.2",
    win: "5.0.2"
  },
}

AUTHORS = {
  'masa' => {
    'name' => "Masahiro Nakagawa",
    'avatar_url' => 'https://avatars1.githubusercontent.com/u/16928?s=70',
    'desc' => 'Masahiro (<a href="https://twitter.com/repeatedly">@repeatedly</a>) is the main maintainer of Fluentd. He works on Fluentd development and support full-time. He is also a committer of the D programming language.'
  },
  'kiyoto' => {
    'name' => 'Kiyoto Tamura',
    'avatar_url' => 'https://avatars3.githubusercontent.com/u/178554?s=70',
    'desc' => 'Kiyoto (<a href="https://twitter.com/kiyototamura">@kiyototamura</a>) is a maintainer of Fluentd. He works on developer marketing and everything related to Fluentd at <a href="http://www.treasuredata.com/">Treasure Data</a>, the cloud-based, managed service for big data.'
  },
  'eduardo' => {
    'name' => 'Eduardo Silva',
    'avatar_url' => 'https://avatars3.githubusercontent.com/u/369718?v=3&s=70',
    'desc' => 'Eduardo (<a href="https://twitter.com/edsiper">@edsiper</a>) is an Open Source Engineer at <a href="http://www.treasuredata.com/">Treasure Data</a>, he is part of Fluentd core team and maintains [Fluent Bit](http://fluentbit.io).'
  },
  'moris' => {
    'name' => 'Satoshi Tagomori',
    'avatar_url' => 'https://avatars3.githubusercontent.com/u/230654?v=3&s=70',
    'desc' => 'Satoshi (a.k.a. Moris) (<a href="https://twitter.com/tagomoris">@tagomoris</a>) is a maintainer of Fluentd. He works on Fluentd, many Fluentd plugins, other OSS projects like msgpack-ruby, Norikra and so on, and distributed systems at <a href="http://www.treasuredata.com/">Treasure Data</a>.'
  },
  'clearcode' => {
    'name' => 'ClearCode, Inc.',
    'avatar_url' => 'https://avatars.githubusercontent.com/u/176515?v=3&s=70',
    'desc' => '<a href="https://www.clear-code.com/">ClearCode, Inc.</a> is a software company specializing in the development of Free Software. We maintain Fluentd and its plugin ecosystem, and provide commercial support for them.'
  },
    'hisa' => {
    'name' => 'Hisa Tanaka',
    'avatar_url' => 'https://avatars.githubusercontent.com/u/19581009?v-3&s=70',
    'desc' => 'Hisa (<a href="https://twitter.com/hisatomot">@hisatomot</a>) is a maintainer of Fluentd. He works on developer marketing and everything related to Fluentd at <a href="http://www.ctc-america.com/">ITOCHU Techno-Solutions America, Inc.</a>, the global IT solution provider, specialized in hyperscale, cloud native and app dev technologies, providing commercial services around Fluentd and Fluent Bit.'
  },
}

N_RECENT_POSTS=10

#
# Contents
#
get '/' do
  erb :index
end

get '/treasuredata' do
  redirect 'http://get.treasuredata.com/fluentd.html', 301
end

get '/architecture' do
  @title = "What is Fluentd?"
  erb :architecture
end

get '/why' do
  @title = "Why use Fluentd?"
  erb :why
end

get '/download' do
  @title = "Download"
  erb :download
end

get '/download/td_agent' do
  # The content will be merged into fluent-package.
  redirect '/download/fluent_package', 301
end

get '/download/fluent_package' do
  @title = "Download Fluent Package"
  erb :download_fluent_package
end

get '/download/calyptia_fluentd' do
  @title = "Download Calyptia Fluentd"
  erb :download_calyptia_fluentd
end

get '/enterprise_services' do
  @title = "Enterprise Services"
  erb :enterprise_services
end

get '/centralized_application_logging' do
  @title = "Centralized Application Logging"
  erb :centralized_application_logging
end

get '/gaming_application_logging' do
  @title = "Gaming Application Logging"
  erb :gaming_application_logging
end

get '/adtech_application_logging' do
  @title = "Adtech Application Logging"
  erb :adtech_application_logging
end

get '/guides' do
  @title = "Guides, Solutions and Examples"
  erb :guides
end

get '/guides/recipes/:type' do
  pass if not File.exist? "content/guides/recipes/#{params[:type]}.md"
  @title, @content = read_markdown("content/guides/recipes/#{params[:type]}.md")
  erb :solution_recipe
end

get '/contributing' do
  @title = "Contributing"
  erb :contributing
end

get '/community' do
  @title = "Community"
  erb :community
end

get '/events' do
  @title = "Events"
  erb :events
end

get '/testimonials' do
  @title = "Testimonials"
  @testimonials = YAML.load_file("content/testimonials.yaml")
  erb :testimonials
end

get '/faqs' do
  @title = "Frequently Asked Questions"
  erb :faqs
end

get '/datasources' do
  @title = "List of Data Sources"
  erb :datasources
end

get '/datasources/:type' do
  pass if not File.exist? "content/datasources/#{params[:type]}.md"
  @title, @content = read_markdown("content/datasources/#{params[:type]}.md")
  erb :datasource_how
end

get '/dataoutputs' do
  @title = "List of Data Outputs"
  erb :dataoutputs
end

get '/dataoutputs/:type' do
  pass if not File.exist? "content/dataoutputs/#{params[:type]}.md"
  @title, @content = read_markdown("content/dataoutputs/#{params[:type]}.md")
  erb :dataoutput_how
end

get '/casestudy/:company' do
  @company = params[:company]
  path_to_file = "content/casestudy/#{@company}.md"
  pass if not File.exist? path_to_file
  @casestudy_title, body_content = File.new(path_to_file).read.split("\n", 2)
  @casestudy_title.gsub!(/^#+/, "")
  @title = @casestudy_title
  @main_content, @profile = body_content.split(/^\n##\s*Profile\s*$/).map {|content|
    MARKDOWN.render(content)
  }
  erb :casestudy
end

get '/enterprise' do
  redirect '/', 301
end

get '/blog' do
  redirect '/blog/', 301
end

get '/blog/' do
  @title = "Blog"
  @articles = read_blog_articles(Dir.glob("content/blog/*.md").sort.reverse.take(5))
  @recent_articles = read_blog_articles(Dir.glob("content/blog/*.md").sort.reverse.take(N_RECENT_POSTS))
  erb :blog
end

get '/blog/feed.rss' do
  @title = "Blog RSS Feed"
  @recent_articles = read_blog_articles(Dir.glob("content/blog/*.md").sort.reverse.take(N_RECENT_POSTS))
  erb :rss, :layout => false
end

get '/newsletter' do
  @title = "Sign up for Fluentd Newsletter"
  erb :newsletter_signup, :layout => :minimal_layout
end

get '/newsletter_thank_you' do
  @title = "Thank you for signing up for Fluentd Newsletter"
  erb :newsletter_thank_you
end

get '/blog/:article' do
  @article = params[:article]
  pass if @article.nil? || @article.empty?
  files = Dir.glob("content/blog/*_#{@article}.md")
  pass if files.nil? || files.empty?
  @article = read_blog_article(files.first)
  @title = @article[:title]
  @recent_articles = read_blog_articles(Dir.glob("content/blog/*.md").sort.reverse.take(N_RECENT_POSTS))
  erb :blog_single
end

get '/blog/tag/:tag' do
  @title = "Blog"
  urls = File.new("content/blog/tag/#{params[:tag]}").read.split("\n").sort.reverse.take(10)
  article_paths = urls.map do |url| "content#{url}.md" end
  @articles = read_blog_articles(article_paths)
  @recent_articles = read_blog_articles(Dir.glob("content/blog/*.md").sort.reverse.take(N_RECENT_POSTS))
  erb :blog
end

get '/videos' do
  @title = "Videos"
  erb :videos
end

get '/slides' do
  @title = "Slides"
  erb :slides
end

get '/plugins' do
  @title = "List of Plugins By Category"

  # Just add items here to populate items on
  # www.fluentd.org/plugins
  # Search terms should be separated by whitespaces
  @search_categories = {
    "Amazon Web Services" => 'amazon aws cloudwatch',
    "Big Data" => 'hdfs hbase hoop treasure',
    "Filter" => 'filter grep modifier replace geoip parse',
    "Google Cloud Platform" => 'google bigquery',
    "Internet of Things" => 'mqtt',
    "Monitoring" => "growthforecast graphite monitor librato zabbix",
    "Notifications" => "slack irc ikachan hipchat twilio",
    "NoSQL" => 'riak couch mongo couchbase rethink influxdb',
    "Online Processing" => 'norikra anomaly',
    "RDBMS" => 'mysql postgres vertica',
    "Search" => 'splunk elasticsearch sumologic'
  }
  @plugins = File.new("scripts/plugins.json").read
  @plugins = JSON.parse(@plugins).map{ |e| e.merge({'certified' => is_certified(e) ? "<center><a href='/faqs#certified'><img src='/images/certified.png'></a></center>" : ""}) }.to_json
  erb :plugins
end

FILTER_PLUGINS = ['fluent-plugin-parser', 'fluent-plugin-geoip', 'fluent-plugin-flatten', 'fluent-plugin-flowcounter-simple', 'fluent-plugin-stats']

get '/plugins/all' do
  @title = "List of All Plugins"
  plugins = File.new("scripts/plugins.json").read
  all_plugins = JSON.parse(plugins)
  @plugins = []
  @obsolete_plugins = []
  @filter_plugins = []
  @parser_plugins = []
  @formatter_plugins = []

  all_plugins.each { |p|
    if p["obsolete"]
      @obsolete_plugins << p
    else
      name = p['name']
      info = p['info']
      if check_plugin_category(name, info, ['filter', 'Filter']) || FILTER_PLUGINS.include?(name)
        @filter_plugins << p
      elsif check_plugin_category(name, info, ['parser', 'Parser'])
        @parser_plugins << p
      elsif check_plugin_category(name, info, ['formatter', 'Formatter'])
        @formatter_plugins << p
      else
        @plugins << p
      end
    end
  }
  erb :plugins_all
end

get '/plugin/' do
  redirect '/plugins', 301
end

get '/related-projects' do
  @title = "Related Projects"
  erb :related_projects
end

get '/coming-soon' do
  erb :coming_soon
end

# Fastly Digicert verification

get '/digicert/verify.html' do
  "Please send the approval email for order #00530261 to kiyoto@treasure-data.com"
end


#
# SEO
#
get '/robots.txt' do
  content_type 'text/plain'
  "User-agent: *\nSitemap: /sitemap.xml\n"
end

get '/sitemap.xml' do
  @articles = []
  Dir.glob('./views/*.erb') { |f|
    name = f.split('/').last.split('.').first
    next if name.start_with?("_") or
            ['index', 'blog', 'blog_single', 'casestudy',
             'coming_soon', 'datasource_how', 'layout', 'sitemap',
             'solution_recipe', 'plugins_all'].include?(name)
    @articles << name
  }
  @articles << 'plugins/all'
  @articles << 'blog/'
  Dir.glob('./content/**/*.md') { |path|
    @articles << path.gsub(/^\.\/content\//, "").gsub(/\.md$/, "").gsub(/\d\d\d\d\d\d\d\d_/, "")
  }
  content_type 'text/xml'
  erb :sitemap, :layout => false
end

CERTIFIED_PLUGINS = %W(firehose kinesis s3 td webhdfs anonymizer filter_typecast geoip grep td-monitoring
grok-parser multi-format-parser parser record-modifier record-reformer woothee rewrite-tag-filter
growthforecast ping-message ikachan twilio mongo influxdb norikra mysql mysql-replicator encrypt
elasticsearch secure-forward forest rewrite scribe flowcounter flowcounter-simple datacounter flatten
grepcounter numeric-counter mail multiprocess slack metricsense extract_query_params notifier keep-forward
twitter munin hash-forward route groupcounter sql netflow elapsed-time stats-notifier copy_ex beats
numeric-monitor kafka).map { |name| "fluent-plugin-#{name}"}

helpers do
  def read_blog_articles(markdown_files)
    markdown_files.map { |f| read_blog_article(f) }
  end

  def read_blog_article(file_path)
    title, content, tags, author = read_markdown(file_path)
    {
        :title   => title,
        :content => content,
        :tags    => tags,
        # YYYYMMDD_url
        :path    => file_path,
        :date    => Time.parse(file_path.split("_")[0]).to_date,
        :url     => file_path.split('_')[1].gsub(/\.md$/, ""),
        :author_name => AUTHORS[author]['name'],
        :author_avatar_url => AUTHORS[author]['avatar_url'],
        :author_desc => AUTHORS[author]['desc']
    }
  end

  def read_markdown(file_path)
    title, rest = File.new(file_path).read.split("\n", 2)
    content, rest = rest.split(/\nTAG:/, 2)
    rest ||= ""
    tags, author  = rest.split(/\nAUTHOR:/, 2)
    tags ||= ""
    author ||= "masa"
    title.gsub!(/^#+/, "")
    return [title, MARKDOWN.render(content), tags.strip.split(/\s+/).map do |tag| tag.downcase end, author.strip]
  end

  def is_certified(plugin)
    CERTIFIED_PLUGINS.include?(plugin['name'])
  end

  def check_plugin_category(name, info, words)
    words.any? { |word| name.include?(word) || info.include?(word) }
  end
end
