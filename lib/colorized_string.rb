# frozen_string_literal: true

require File.expand_path('colorize/errors', File.dirname(__FILE__))
require File.expand_path('colorize/class_methods', File.dirname(__FILE__))
require File.expand_path('colorize/instance_methods', File.dirname(__FILE__))
#
# ColorizedString class extension.
#
class ColorizedString < String
  extend Colorize::ClassMethods
  include Colorize::InstanceMethods

  color_methods
  modes_methods

  add_color_alias(:grey, :light_black) unless color_exist?(:grey)
  add_color_alias(:gray, :light_black) unless color_exist?(:gray)

  #
  # Shortcut to create ColorizedString with ColorizedString['test'].
  #
  def self.[](string)
    ColorizedString.new(string)
  end
end
