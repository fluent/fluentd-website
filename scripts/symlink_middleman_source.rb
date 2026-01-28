#!/usr/bin/ruby

require 'pastel'
require 'find'
require 'fileutils'

top_dir = File.expand_path("../..", __FILE__)

def make_symlink(source, target, dir)
  pastel = Pastel.new
  unless File.symlink?(target)
    begin
      File.symlink(source, target)
      puts pastel.green.on_black("[PASS]") + " #{target} was created in #{dir}"
    rescue => e
      puts pastel.red.on_black("[ERROR]") + " #{e.message}: failed to create symlink from <#{source}> => <#{target}> in #{dir}"
    end
  else
    puts pastel.magenta.on_black("[SKIP]") + " #{target} exists in #{dir}"
  end
end

Dir.chdir('source') do |dir|
  # public assets
  %w(favicon.ico highlight images fonts).each do |target|
    make_symlink("../public/#{target}", target, dir)
  end

  # javascripts
  FileUtils.mkdir_p('javascripts/flexslider')
  Dir.chdir('javascripts') do |js_dir|
    Dir.glob('../../assets/js/*').each do |path|
      target = File.basename(path)
      make_symlink(path, target, js_dir)
    end
    Dir.glob('../../assets/plugins/*.js').each do |path|
      target = File.basename(path)
      make_symlink(path, target, js_dir)
    end
    make_symlink('../../assets/plugins/bootstrap/js', 'bootstrap', js_dir)
    make_symlink('../../assets/plugins/parallax-slider/js', 'parallax-slider', js_dir)
    Dir.chdir('flexslider') do |flexslider_dir|
      Dir.glob('../../../assets/plugins/flexslider/*.js').each do |path|
        target = File.basename(path)
        make_symlink(path, target, flexslider_dir)
      end
    end
  end

  # stylesheets
  FileUtils.mkdir_p('stylesheets/flexslider')
  Dir.chdir('stylesheets') do |css_dir|
    Dir.glob('../../assets/css/*').each do |path|
      # use customized version of application.css
      next if path.end_with?('application.css')
      target = File.basename(path)
      make_symlink(path, target, css_dir)
    end
    make_symlink('../../assets/plugins/bootstrap/css', 'bootstrap', css_dir)
    make_symlink('../../assets/plugins/bootstrap/fonts', 'fonts', css_dir)
    make_symlink('../../assets/plugins/parallax-slider/css', 'parallax-slider', css_dir)
    make_symlink('../../assets/plugins/font-awesome/css', 'font-awesome', css_dir)
    make_symlink('../../assets/plugins/font-awesome/font', 'fonts', css_dir)
    Dir.chdir('flexslider') do |flexslider_dir|
      make_symlink('../../assets/plugins/flexslider/flexslider.css', 'flexslider.css', flexslider_dir)
      make_symlink('../../assets/plugins/flexslider/images', 'images', flexslider_dir)
    end
  end
  
  # blog
  FileUtils.mkdir_p('blog')
  Dir.chdir('blog') do |blog_dir|
    Dir.glob('../../content/blog/*.md') do |src|
      md = File.basename(src)
      #make_symlink(src, md, blog_dir)
    end
  end
end
