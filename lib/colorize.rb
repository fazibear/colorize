require File.expand_path('colorize/class_methods', File.dirname(__FILE__))
require File.expand_path('colorize/instance_methods', File.dirname(__FILE__))
#
# Object class extension.
#
class Object
  extend Colorize::ClassMethods
  include Colorize::InstanceMethods

  color_methods
  modes_methods
end
