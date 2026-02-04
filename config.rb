
# Use default directory layout
set :source, "source"
set :build_dir, "build"
set :layouts_dir, "layouts"
set :css_dir, "stylesheets"
set :js_dir,  "javascripts"

set :markdown_engine, :redcarpet
set :markdown,
    fenced_code_blocks: true,
    smartypants: false, # disable &quot; conversion
    tables: true

activate :directory_indexes

# For *.github.io/fluentd-website
set :http_prefix, '/fluentd-website/'

# For fluentd.org
#set :http_prefix, '/'

helpers do
  def is_certified(plugin)
    certified_plugins = YAML.load_file('data/certified_plugins.yml')
    certified_plugins.include?(plugin['name'])
  end

  def http_prefix
    config[:http_prefix]
  end
end

# Do not use 'helpers do' block to use them in config.rb.
def read_markdown(file_path)
  title, rest = File.new(file_path).read.split("\n", 2)
  content, rest = rest.split(/\nTAG:/, 2)
  rest ||= ""
  tags, author  = rest.split(/\nAUTHOR:/, 2)
  tags ||= ""
  author ||= "masa"
  title.gsub!(/^#+/, "")
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, fenced_code_blocks: true)
  return [title, "#{markdown.render(content)}", tags.strip.split(/\s+/).map do |tag| tag.downcase end, author.strip]
end

def read_blog_article(file_path)
  authors = YAML.load_file 'data/authors.yml'
  title, content, tags, author = read_markdown(file_path)
  {
    :title   => title,
    :content => content,
    :tags    => tags,
    # YYYYMMDD_url
    :path    => file_path,
    :date    => Time.parse(file_path.split("_")[0]).to_date,
    :url     => file_path.split('_')[1].gsub(/\.md$/, ""),
    :author_name => authors[author]['name'],
    :author_avatar_url => authors[author]['avatar_url'],
    :author_desc => authors[author]['desc']
  }
end

def read_blog_articles(markdown_files)
  markdown_files.map { |f| read_blog_article(f) }
end

def blog_posts_all(prefix)
  Dir.glob(File.join("content/blog/*.md"))
    .sort
    .reverse
    .filter_map do |path|
      if m = path.match(%r{content/blog/(\d{4})(\d{2})(\d{2})_(.+)\.md$})
        y, mo, d, article = m.captures
        title = begin
          first = File.open(path, &:readline)
          first.sub(/^#\s*/, '').strip
        end
        {
          date: Date.new(y.to_i, mo.to_i, d.to_i),
          url:  "#{prefix}blog/#{article}",
          title: title,
        }
      end
    end
end

def check_plugin_category(name, info, words)
  words.any? { |word| name.include?(word) || info.include?(word) }
end

# Redirect /treasuredata
proxy "/treasuredata/index.html",
      "index.html",
      locals: { meta_redirect: true,
                canonical: "http://get.treasuredata.com/fluentd.html",
                timeout: 0 }

# /datasources/:type
Dir.glob("content/datasources/*.md").each do |md|
  type = File.basename(md, '.md')
  # To keep layout compatibility, fetch title via content/datasources/
  # instead of source/datasources/.
  title, _ = read_markdown(md)
  proxy "/datasources/#{type}/index.html",
        "datasource_how.html",
        data: {
          title: title,
        },
        locals: {
          title: title,
          content_path: "datasources/#{type}.md"
        },
        ignore: true
end

# /testimonials
testimonials = YAML.load_file("content/testimonials.yaml")
proxy "/testimonials/index.html",
      "testimonials.html",
      locals: {
        testimonials: testimonials,
      },
      ignore: true

# /guides/recipes/:type
recipes = Dir.glob("content/guides/recipes/*.md")
recipes.each do |md|
  type = File.basename(md, ".md")
  # To keep layout compatibility, fetch title via content/guides/recipes/
  # instead of source/guides/recipes/.
  title, _ = read_markdown(md) 
  proxy "/guides/recipes/#{type}/index.html",
        "solution_recipe.html",
        data: {
          title: title,
        },
        locals: {
          title: title,
          content_path: "guides/recipes/#{type}.md",
        },
        ignore: true
end

# /casestudy/:company
companies = Dir.glob("content/casestudy/*.md")
companies.each do |md|
  type = File.basename(md, ".md")
  casestudy_title, body_content = File.new(md).read.split("\n", 2)
  casestudy_title.gsub!(/^#+/, "")
  title = casestudy_title
  main_content, profile = body_content.split(/^\n##\s*Profile\s*$/).map {|content|
    Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            autolink: true,
                            tables: true,
                            fenced_code_blocks: true).render(content)
  }
  proxy "/casestudy/#{type}/index.html",
        "casestudy.html",
        data: {
          title: casestudy_title
        },
        locals: {
          casestudy_title: casestudy_title,
          main_content: main_content,
          profile: profile
        },
        ignore: true
end

# /newsletter
proxy "/newsletter/index.html",
      "newsletter_signup.html",
      data: {
        title: "Sign up for Fluentd Newsletter"
      },
      locals: {
        title: "Sign up for Fluentd Newsletter"
      },
      layout: "minimal_layout",
      ignore: true

# /plugins
search_categories = {
  "Amazon Web Services" => 'amazon aws cloudwatch',
  "Big Data" => 'hdfs hbase hoop treasure',
  "Filter" => 'filter grep modifier replace geoip parse',
  "Google Cloud Platform" => 'google bigquery',
  "Internet of Things" => 'mqtt',
  "Monitoring" => "growthforecast graphite monitor librato zabbix opentelemetry",
  "Notifications" => "slack irc ikachan hipchat twilio",
  "NoSQL" => 'riak couch mongo couchbase rethink influxdb',
  "Online Processing" => 'norikra anomaly',
  "RDBMS" => 'mysql postgres vertica',
  "Search" => 'splunk elasticsearch sumologic'
}
certified_plugins = YAML.load_file('data/certified_plugins.yml')
plugins = File.new("scripts/plugins.json").read
plugins = JSON.generate(JSON.parse(plugins).map{ |e|
  e.merge({'certified' => certified_plugins.include?(e['name']) ? "<center><a href='#{config[:http_prefix]}faqs#certified'><img src='#{config[:http_prefix]}images/certified.png'></a></center>" : ""})
}, ascii_only: false) # avoid \uXXX encoder
proxy "/plugins/index.html",
      "plugins.html",
      locals: {
        title: "List of Plugins By Category",
        plugins: plugins,
        search_categories: search_categories
      },
      ignore: true

# /plugins/all
plugins = File.new("scripts/plugins.json").read
all_plugins = JSON.parse(plugins)
plugins = []
obsolete_plugins = []
filter_plugins = []
parser_plugins = []
formatter_plugins = []

FILTER_PLUGINS = ['fluent-plugin-parser', 'fluent-plugin-geoip', 'fluent-plugin-flatten', 'fluent-plugin-flowcounter-simple', 'fluent-plugin-stats']

all_plugins.each { |plugin|
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                     autolink: true, tables: true, fenced_code_blocks: true)
  if plugin['note']
    plugin['note'] = markdown.render(plugin['note'])
  end
  if plugin["obsolete"]
    obsolete_plugins << plugin
  else
    name = plugin['name']
    info = plugin['info']
    if check_plugin_category(name, info, ['filter', 'Filter']) || FILTER_PLUGINS.include?(name)
      filter_plugins << plugin
    elsif check_plugin_category(name, info, ['parser', 'Parser'])
      parser_plugins << plugin
    elsif check_plugin_category(name, info, ['formatter', 'Formatter'])
      formatter_plugins << plugin
    else
      plugins << plugin
    end
  end
}
proxy "/plugins/all/index.html",
      "plugins/all.html",
      data: {
        title: "List of All Plugins",
      },
      locals: {
        title: "List of All Plugins",
        plugins: plugins,
        filter_plugins: filter_plugins,
        parser_plugins: parser_plugins,
        formatter_plugins: formatter_plugins,
        obsolete_plugins: obsolete_plugins
      }
ignore "plugins/all.html.erb"

# /related-projects
proxy "/related-projects/index.html",
      "related_projects.html",
      data: {
        title: "Related Projects"
      },
      locals: {
        testimonials: testimonials,
      },
      ignore: true

ignore "blog_single.html.erb"

# redirect /download/td_agent => fluent_package
proxy "/download/td_agent/index.html",
      "index.html",
      locals: { meta_redirect: true,
                canonical: "fluent_package",
                timeout: 0 }

# /blog/feed.rss
N_RECENT_POSTS=10
recent_articles = read_blog_articles(Dir.glob("content/blog/*.md").sort.reverse.take(N_RECENT_POSTS))
proxy "/blog/feed.rss",
      "rss.xml",
      locals: {
        recent_articles: recent_articles,
      },
      layout: false,
      ignore: true

# /blog/
articles = read_blog_articles(Dir.glob("content/blog/*.md").sort.reverse.take(5))
recent_reminder = read_blog_articles(Dir.glob("content/blog/*.md").sort.reverse).select do |article|
  article[:tags].include?("reminder")
end
proxy "/blog/index.html",
      "blog.html",
      locals: {
        articles: articles,
        recent_articles: recent_articles,
        recent_reminder: recent_reminder
      },
      ignore: true

# /blog/archive
proxy "/blog/archive/index.html",
      "blog_archive.html",
      locals: {
        posts: blog_posts_all(config[:http_prefix])
      },
      ignore: true

# /blog/:tag
Dir.glob("content/blog/tag/*").map { |path| File.basename(path) }.each do |tag|
  urls = File.new("content/blog/tag/#{tag}").read.split("\n").sort.reverse.take(10)
  article_paths = urls.map do |url| "content#{url}.md" end
  articles = read_blog_articles(article_paths)
  proxy "/blog/tag/#{tag}/index.html",
        "blog.html",
        locals: {
          articles: articles,
          recent_articles: recent_articles,
          recent_reminder: recent_reminder
        },
        ignore: true
  # /blog/tag/:tag/:article
  article_paths.each do |article_path|
    caption = File.basename(article_path.split('_', 2).last, '.md')
    article = read_blog_article(article_path)
    title = article[:title]
    proxy "/blog/tag/#{tag}/#{caption}/index.html",
          "blog_single.html",
          data: {
            title: title,
          },
          locals: {
            title: title,
            article: article,
            recent_articles: recent_articles,
            recent_reminder: recent_reminder
          },
          ignore: true
  end
end

# /blog/:article
Dir.glob("content/blog/*.md").each do |path|
  caption = File.basename(path.split('_', 2).last, '.md')
  next if caption.nil? || caption.empty?
  article = read_blog_article(path)
  title = article[:title]
  proxy "/blog/#{caption}/index.html",
        "blog_single.html",
        data: {
          title: title,
        },
        locals: {
          title: title,
          article: article,
          recent_articles: recent_articles,
          recent_reminder: recent_reminder
        },
        ignore: true
end

# redirect /enterprise
proxy "/enterprise/index.html",
      "index.html",
      locals: { meta_redirect: true,
                canonical: "/",
                timeout: 0 }

# /sitemap.xml
ignore_sitemap_urls = %w[
/blog
/blog/archive
/download/td_agent
/enterprise
/plugin/
/related-projects
/treasuredata
]
set :url_root, 'https://www.fluentd.org'
activate :search_engine_sitemap, process_url: -> (url) { url.chomp('/') }, exclude_if: ->(resource) {
  ignore_sitemap_urls.any? { |url| resource.url[0..-2].end_with?(url) }
}

# /robots.txt
# config.rb
activate :robots, 
  rules: [
    { user_agent: '*', allow: %w[/] }
  ],
  sitemap: 'https://www.fluentd.org/sitemap.xml'

# /digicert/verify.html
proxy "/digicert/verify.html",
       "digicert_verify.html",
       layout: false,
       directory_index: false,
       ignore: true
