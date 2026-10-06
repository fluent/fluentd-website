require "erb"
require "nokogiri"

module OGP
  SITE_NAME = "Fluentd"
  LOCALE = "en_US"
  TWITTER_SITE = "@fluentd"
  DEFAULT_TITLE = "Fluentd | Open Source Data Collector"
  IMAGE = "/images/ogp/default.png"
  IMAGE_WIDTH = 438
  IMAGE_HEIGHT = 438
  IMAGE_ALT = "Fluentd logo"
  DESCRIPTION_LENGTH = 200
  GREETING = /\A(?:hi|hello)\b[^.!?]{0,40}[!,.]?\z/i

  module_function

  def description_from_html(html, length = DESCRIPTION_LENGTH)
    fragment = Nokogiri::HTML::DocumentFragment.parse(html)
    fragment.css("pre, table, h1, h2, h3, h4, h5, h6, img, script, style").remove
    blocks = fragment.children.map { |node| node.text.gsub(/\s+/, " ").strip }.reject(&:empty?)
    blocks.shift while blocks.first&.match?(GREETING)
    truncate(blocks.join(" "), length)
  end

  def truncate(text, length)
    return text if text.length <= length

    cut = text[0, length - 1]
    cut = cut.sub(/\s+\S*\z/, "") unless text[length - 1].match?(/\s/)
    cut.sub(/[\s,;:]+\z/, "") + "…"
  end

  def meta_tag(attribute, key, value)
    %(<meta #{attribute}="#{key}" content="#{ERB::Util.html_escape(value)}">)
  end

  module Helpers
    def ogp_meta_tags
      article = current_page.locals[:article]
      url_root = config[:url_root]

      page_title = current_page.data.title.to_s.strip
      title = page_title.empty? ? OGP::DEFAULT_TITLE : "#{page_title} | #{OGP::SITE_NAME}"

      tags = []
      if article
        description = OGP.description_from_html(article[:content])
        tags << [:name, "description", description]
        tags << [:property, "og:site_name", OGP::SITE_NAME]
        tags << [:property, "og:locale", OGP::LOCALE]
        tags << [:property, "og:type", "article"]
        tags << [:property, "og:title", title]
        tags << [:property, "og:description", description]
        tags << [:property, "og:url", "#{url_root}/blog/#{article[:url]}/"]
        tags << [:property, "og:image", url_root + OGP::IMAGE]
        tags << [:property, "og:image:width", OGP::IMAGE_WIDTH]
        tags << [:property, "og:image:height", OGP::IMAGE_HEIGHT]
        tags << [:property, "og:image:alt", OGP::IMAGE_ALT]
        tags << [:property, "article:published_time", article[:date].iso8601]
        article[:tags].each { |tag| tags << [:property, "article:tag", tag] }
        tags << [:name, "twitter:card", "summary"]
        tags << [:name, "twitter:site", OGP::TWITTER_SITE]
        tags << [:name, "twitter:title", title]
        tags << [:name, "twitter:image:alt", OGP::IMAGE_ALT]
      else
        tags << [:property, "og:title", title]
        tags << [:name, "twitter:title", title]
      end

      tags.map { |attribute, key, value| OGP.meta_tag(attribute, key, value) }.join("\n")
    end
  end
end
