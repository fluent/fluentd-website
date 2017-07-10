# Fluentd website

[https://www.fluentd.org](https://www.fluentd.org)

## Running it locally

```
$ bundle install --path vendor
$ bundle exec rake server
```

## Blog

- Each blog entry is a single file under content/blog/yyyy/MM/dd/slugified-name.md
- Blog entries can be written in the GitHub flavored markdown format.
- If you want to add a tag, add a line at the end like this:
    ```
    TAG: tag1 tag2 tag3
    ```
- Then, before you push to master, make sure you run
    ```
    ruby scripts/generate_tags.rb
    ```

This must be the world's most sophisticated blog system.

## Plugins page

### How to mark a plugin as obsolete

Find the global array `OBSOLETE\_PLUGINS` inside `scripts/plugin.rb` and add the name of the plugin as listed on Rubygems. When the script is run the next time, the change should be reflected.
