#
# Colorize String class extension.
#
class String

  START_PATTERN = /^\033\[(?<mode>[0-9]+);(?<color>[0-9]+);(?<background>[0-9]+)m/
  END_PATTERN = /\033\[0m$/
  COLOR_OFFSET = 30
  BACKGROUND_OFFSET = 40
    
  #
  # Colors Hash
  #
  COLORS = {
    :black          => 0,
    :red            => 1,
    :green          => 2,
    :yellow         => 3,
    :blue           => 4,
    :magenta        => 5,
    :cyan           => 6,
    :white          => 7,
    :default        => 9,

    :light_black    => 60,
    :light_red      => 61,
    :light_green    => 62,
    :light_yellow   => 63,
    :light_blue     => 64,
    :light_magenta  => 65,
    :light_cyan     => 66,
    :light_white    => 67
  }

  #
  # Modes Hash
  #
  MODES = {
    :default        => 0, # Turn off all attributes
    :bold           => 1, # Set bold mode
    :underline      => 4, # Set underline mode
    :blink          => 5, # Set blink mode
    :swap           => 7, # Exchange foreground and background colors
    :hide           => 8  # Hide text (foreground color would be the same as background)
  }

  #
  # Change color of string
  #
  # Examples:
  #
  #   puts "This is blue".colorize(:blue)
  #   puts "This is light blue".colorize(:light_blue)
  #   puts "This is also blue".colorize(:color => :blue)
  #   puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)
  #   puts "This is light blue with red background".colorize(:light_blue ).colorize( :background => :red)
  #   puts "This is blue text on red".blue.on_red
  #   puts "This is red on blue".colorize(:red).on_blue
  #   puts "This is red on blue and underline".colorize(:red).on_blue.underline
  #   puts "This is blue text on red".blue.on_red.blink
  #   puts "This is uncolorized".blue.on_red.uncolorize
  #
  def colorize(params)
    begin
      require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
    rescue LoadError
      raise 'You must gem install win32console to use colorize on Windows'
    end
    
    params = (COLORS[params] ? {color: params} : params)
    color, background, mode = COLORS[params[:color]], COLORS[params[:background]], MODES[params[:mode]]
    color += COLOR_OFFSET if color
    background += BACKGROUND_OFFSET if background

    str = ''
    if match = self.match(START_PATTERN)
      color ||= match[:color].to_i
      background ||= match[:background].to_i
      mode ||= match[:mode].to_i
      str << self.gsub(START_PATTERN, '')
    else
      color ||= COLORS[:default] + COLOR_OFFSET
      background ||= COLORS[:default] + BACKGROUND_OFFSET
      mode ||= MODES[:default]
      str << "#{self}\033[0m"
    end
    
    str.prepend "\033[#{mode};#{color};#{background}m"
  end

  #
  # Return uncolorized string
  #
  def uncolorize
    self.gsub(Regexp.union(START_PATTERN, END_PATTERN), '')
  end

  #
  # Return true if string is colorized
  #
  def colorized?
    !!(self =~ START_PATTERN)
  end

  #
  # Make some color and on_color methods
  #
  COLORS.each_key do |key|
    next if key == :default

    define_method key do
      self.colorize(:color => key)
    end

    define_method "on_#{key}" do
      self.colorize(:background => key)
    end
  end

  #
  # Methods for modes
  #
  MODES.each_key do |key|
    next if key == :default

    define_method key do
      self.colorize(:mode => key)
    end
  end

  class << self

    #
    # Return array of available modes used by colorize method
    #
    def modes
      MODES.keys
    end

    #
    # Return array of available colors used by colorize method
    #
    def colors
      COLORS.keys
    end

    #
    # Display color matrix with color names
    #
    def color_matrix(txt = '[X]')
      size = String.colors.length
      String.colors.each do |color|
        String.colors.each do |back|
          print txt.colorize(:color => color, :background => back)
        end
        puts " < #{color}"
      end
      String.colors.reverse.each_with_index do |back, index|
        puts "#{"|".rjust(txt.length)*(size-index)} < #{back}"
      end
      ''
    end

  end
end
