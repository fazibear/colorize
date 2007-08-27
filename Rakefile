# -*- ruby -*-
require 'rubygems'
require 'hoe'
require "#{File.dirname(__FILE__)}/lib/colorize.rb"

ENV['VERSION'] = String::COLORIZE_VERSION

# Little hack to set rdoc template
module Rake
  class RDocTask
    alias_method :old_option_list, :option_list
    def option_list
      result = old_option_list
      @template = "allison/allison.rb"
      result << "-T" << quote(template) if template
      result
    end
  end 
end

Hoe.new('colorize', String::COLORIZE_VERSION) do |p|
  p.rubyforge_name = 'colorize'
  p.author = 'Michal Kalbarczyk (FaziBear)'
  p.email = 'fazibear@gmail.com'
  p.url = ['http://colorize.rubyforge.org', 'http://fazibear.prv.pl']
  p.summary = "Add colors methods to string class"
  p.description = "Ruby string class extension. It add some methods to set color, background color and text effect on console easier. Uses ANSI escape sequences."
  p.need_zip = true
  p.remote_rdoc_dir = ''
end

desc "Generate Manifest.new for dist"
task :manifest do
  File.open("Manifest.new", "wb") { |manifest|
    Dir["**/*"].each { |file|
      manifest.puts file  if File.file? file
    }
  }
end
