# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'colorize'
  s.version = '0.8.1'
  s.required_ruby_version = '>= 2.6'

  s.authors = ['Michał Kalbarczyk']
  s.email = 'fazibear@gmail.com'

  s.homepage = 'http://github.com/fazibear/colorize'
  s.description = 'Extends String class or add a ColorizedString with methods to set text color, background color and text effects.'
  s.summary = 'Ruby gem for colorizing text using ANSI escape sequences.'
  s.license = 'GPL-2.0'

  s.require_paths = ['lib']

  s.add_development_dependency 'json', '~> 2.0'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop', '~> 1.0'
  s.add_development_dependency 'rubocop-github', '~> 0.20'
  s.add_development_dependency 'rubocop-minitest', '~> 0.29.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.16'
  s.add_development_dependency 'rubocop-rake', '~> 0.6'

  s.files = [
    'LICENSE',
    'CHANGELOG',
    'README.md',
    'Rakefile',
    'colorize.gemspec',
    'lib/colorize.rb',
    'lib/colorized_string.rb',
    'lib/colorize/class_methods.rb',
    'lib/colorize/instance_methods.rb',
    'test/test_colorize.rb',
  ]

  s.metadata['rubygems_mfa_required'] = 'true'
end
