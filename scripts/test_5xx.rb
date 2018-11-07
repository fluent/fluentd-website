ENV['RACK_ENV'] = 'test'

require './app'
require 'test/unit'
require 'rack/test'

class FluentdWebsiteTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  data('top' => '',
       'adtech_application_logging' => 'adtech_application_logging',
       'centralized_application_logging' => 'centralized_application_logging',
       'gaming_application_logging' => 'gaming_application_logging',
       'architecture' => 'architecture',
       'coming-soon' => 'coming-soon',
       'community' => 'community',
       'contributing' => 'contributing',
       'dataoutputs' => 'dataoutputs',
       'datasources' => 'datasources',
       'download' => 'download',
       'events' => 'events',
       'faqs' => 'faqs',
       'guides' => 'guides',
       'newsletter' => 'newsletter',
       'newsletter_thank_you' => 'newsletter_thank_you',
       'plugins' => 'plugins',
       'plugins_all' => 'plugins/all',
       'related-projects' => 'related-projects',
       'slides' => 'slides',
       'testimonials' => 'testimonials',
       'videos' => 'videos',
       'what_is_fluentd' => 'architecture',
       'why_use_fluentd' => 'why',
       'blog' => 'blog/',
       'blog_kiyoto' => 'blog/unified-logging-layer',
       'blog_masa' => 'blog/fluentd-v0.12-is-released',
       'blog_rss' => 'blog/feed.rss')
  test("popular pages for 5xx") do |path|
    get path
    assert last_response.ok?
  end

  data do
    tags = []
    Dir.glob("./content/blog/*.md") do |path|
      tags.concat(File.readlines(path, chomp: true).grep(/^TAG:\s+/).first.sub(/TAG:\s+/, "").split(/ +/))
    end
    hash = {}
    tags.sort.uniq.each do |tag|
      hash[tag] = tag.downcase
    end
    hash
  end
  test "blog/tag/:tag" do |tag|
    get "blog/tag/#{tag}"
    assert last_response.ok?
  end

  data do
    hash = {}
    Dir.glob("./content/{blog,casestudy,datasources,guides/recipes}/*.md") do |path|
      hash[path] = path.sub(%r!\A\./content/(blog|casestudy|datasources|guides/recipes)/(.+?)\.md\z!) do
        if $1 == "blog"
          article = $2.sub(/\A\d{8}_(.+?)\z/) { $1 }
          "blog/#{article}"
        else
          "#{$1}/#{$2}"
        end
      end
    end
    hash
  end
  test "all content" do |path|
    get path
    assert last_response.ok?
  end
end
