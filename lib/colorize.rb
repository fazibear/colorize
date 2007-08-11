Dir[File.join(File.dirname(__FILE__), 'colorize/**/*.rb')].sort.each { |lib| require lib }
class Colorize
  VERSION = '0.5.5' 
end
