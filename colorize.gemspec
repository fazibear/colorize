Gem::Specification.new do |s|
  s.name = "colorize"
  s.version = "0.6.0"

  s.authors = ["fazibear"]
  s.email = "fazibear@gmail.com"
  
  s.date = "2012-09-15"
  
  s.homepage = "http://github.com/fazibear/colorize"
  s.description = "Ruby String class extension. Adds methods to set text color, background color and, text effects on ruby console and command line output, using ANSI escape sequences."
  s.summary = "Add color methods to String class"
  s.license = 'GPL'

  s.require_paths = ["lib"]
  
  s.files = [
     "CHANGELOG.rdoc",
     "README.rdoc",
     "Rakefile",
     "colorize.gemspec",
     "lib/colorize.rb",
     "test/test_colorize.rb",
     "test/test_helper.rb"
  ]
  s.test_files = [
    "test/test_helper.rb",
    "test/test_colorize.rb"
  ]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
end
