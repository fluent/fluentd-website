# Fluentd website

[https://www.fluentd.org](https://www.fluentd.org)

## Running it locally

```
$ BUNDLE_GEMFILE=Gemfile.middleman bundle install
$ BUNDLE_GEMFILE=Gemfile.middleman bundle exec middleman server
```

Then you can preview via http://localhost:4567.

## Blog

- Each blog entry is a single file under content/blog/yyyy/MM/dd/slugified-name.md
- Blog entries can be written in the GitHub flavored markdown format.
- If you want to add a tag, add a line at the end like this:
    ```
    TAG: tag1 tag2 tag3
    ```
- Before you push to master, make sure you run
    ```
    bundle exec rake update_tags
    ```

This must be the world's most sophisticated blog system.

## Plugins page

### How to mark a plugin as obsolete

Find the global array `OBSOLETE\_PLUGINS` inside `scripts/plugin.rb` and add the name of the plugin as listed on Rubygems to `scripts/obsolete-plugins.yml`. When the script is run the next time, the change should be reflected.
