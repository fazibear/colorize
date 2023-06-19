# frozen_string_literal: true

require File.expand_path('lib/colorize/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = 'colorize'
  s.version = Colorize::VERSION
  s.required_ruby_version = '>= 2.6'

  s.authors = ['Michał Kalbarczyk']
  s.email = 'fazibear@gmail.com'

  s.homepage = 'http://github.com/fazibear/colorize'
  s.description = 'Extends String class or add a ColorizedString with methods to set text color, background color and text effects.'
  s.summary = 'Ruby gem for colorizing text using ANSI escape sequences.'
  s.license = 'GPL-2.0'

  s.require_paths = ['lib']

  s.files = [
    'LICENSE',
    'CHANGELOG.md',
    'README.md',
    'Rakefile',
    'colorize.gemspec',
    'lib/colorize.rb',
    'lib/colorized_string.rb',
    'lib/colorize/errors.rb',
    'lib/colorize/class_methods.rb',
    'lib/colorize/instance_methods.rb',
    'lib/colorize/version.rb',
    'test/test_colorize.rb',
    'test/test_colorized_string.rb',
  ]

  s.metadata['rubygems_mfa_required'] = 'true'
end
