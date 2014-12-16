Gem::Specification.new do |s|
  s.name = 'colorize'
  s.version = '0.7.5'

  s.authors = ['fazibear']
  s.email = 'fazibear@gmail.com'
  
  s.date = Time.now.strftime("%Y-%m-%d")
  
  s.homepage = 'http://github.com/fazibear/colorize'
  s.description = 'Ruby String class extension. Adds methods to set text color, background color and, text effects on ruby console and command line output, using ANSI escape sequences.'
  s.summary = 'Add color methods to String class'
  s.license = 'GPL-2'

  s.require_paths = ['lib']
  
  s.files = [
    'LICENSE',
    'CHANGELOG',
    'README.md',
    'Rakefile',
    'colorize.gemspec',
    'lib/colorize.rb',
    'lib/colorize/class_methods.rb',
    'lib/colorize/instance_methods.rb',
    'test/test_colorize.rb',
  ]
  s.test_files = [
    'test/test_colorize.rb'
  ]
end
