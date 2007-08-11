# -*- ruby -*-
require 'rubygems'
require 'hoe'
require "#{File.dirname(__FILE__)}/lib/colorize.rb"

ENV['VERSION'] = Colorize::VERSION

Hoe.new('colorize', Colorize::VERSION) do |p|
  p.rubyforge_name = 'colorize'
  p.author = 'fazibear'
  p.email = 'fazibear@gmail.com'
  p.summary = "Ruby string class extension. It add some methods to set color, background color and text effect on console easier using ANSI escape sequences."
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.need_zip = true
end

desc "Generate Manifest.new for dist"
task :manifest do
  File.open("Manifest.new", "wb") { |manifest|
    Dir["**/*"].each { |file|
      manifest.puts file  if File.file? file
    }
  }
end
