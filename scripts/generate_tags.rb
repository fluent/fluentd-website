#!/usr/bin/env ruby

root_dir = File.expand_path('../..', __FILE__)
Dir.chdir(root_dir)

tags2links = {}

Dir.glob("content/blog/*.md") { |f|
  permalink = f.gsub(/^content/, "").gsub(/\.md$/, "")
  tags = (File.read(f).split("\n").select do |line| /^TAG:/.match(line) end).first
  next if not tags
  tags = tags.gsub(/^TAG:\s+/, "").split(/[ ]+/)
  tags.each do |tag|
    tag.downcase!
    tags2links[tag] ||= []
    tags2links[tag] << permalink
  end
}

tags2links.each do |tag, links|
  fh = File.new("content/blog/tag/#{tag}", 'w')
  fh.write(links.join("\n"))
  fh.close
end
