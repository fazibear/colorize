#
# Colorize String class extension.
#
class String

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

  REGEXP_PATTERN = /\033\[([0-9]+);([0-9]+);([0-9]+)m(.+?)\033\[0m|([^\033]+)/m
  COLOR_OFFSET = 30
  BACKGROUND_OFFSET = 40

  public

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
    windows_requires

    scan(REGEXP_PATTERN).inject('') do |str, match|
      set_defaults(match)
      set_from_params(match, params)
      str << "\033[#{match[0]};#{match[1]};#{match[2]}m#{match[3]}\033[0m"
    end
  end

  #
  # Return uncolorized string
  #
  def uncolorize
    scan(REGEXP_PATTERN).inject('') do |str, match|
      str << (match[3] || match[4])
    end
  end

  #
  # Return true if string is colorized
  #
  def colorized?
    scan(REGEXP_PATTERN).reject(&:last).any?
  end

  #
  # Make some color and on_color methods
  #
  COLORS.each_key do |key|
    next if key == :default

    define_method key do
      colorize(:color => key)
    end

    define_method "on_#{key}" do
      colorize(:background => key)
    end
  end

  #
  # Methods for modes
  #
  MODES.each_key do |key|
    next if key == :default

    define_method key do
      colorize(:mode => key)
    end
  end

  private

  #
  # Require windows libs
  #
  def windows_requires
    begin
      require 'Win32/Console/ANSI' if RUBY_VERSION < "2.0.0" && RUBY_PLATFORM =~ /win32/
    rescue LoadError
      raise 'You must gem install win32console to use colorize on Windows'
    end
  end

  #
  # Set default colors
  #
  def set_defaults(match)
    match[0] ||= MODES[:default]
    match[1] ||= COLORS[:default] + COLOR_OFFSET
    match[2] ||= COLORS[:default] + BACKGROUND_OFFSET
    match[3] ||= match[4]
  end

  #
  # Set color from params
  #
  def set_from_params(match, params)
    case params
    when Hash then set_from_hash(match, params)
    when Symbol then set_from_symbol(match, params)
    end
  end

  #
  # Set colors from params hash
  #
  def set_from_hash(match, hash)
    match[0] = MODES[hash[:mode]] if hash[:mode] && MODES[hash[:mode]]
    match[1] = COLORS[hash[:color]] + COLOR_OFFSET if hash[:color] && COLORS[hash[:color]]
    match[2] = COLORS[hash[:background]] + BACKGROUND_OFFSET if hash[:background] && COLORS[hash[:background]]
  end

  #
  # Set color from params symbol
  #
  def set_from_symbol(match, symbol)
    match[1] = COLORS[symbol] + COLOR_OFFSET if symbol && COLORS[symbol]
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
    # Display color samples
    #
    def color_samples
      String.colors.permutation(2).each do |background, color|
        puts "#{color.inspect.rjust(15)} on #{background.inspect.ljust(15)}".colorize(:color => color, :background => background) + "#{color.inspect.rjust(15)} on #{background.inspect.ljust(15)}"
      end
    end

    #
    # Method removed, raise NoMethodError
    #
    def color_matrix(txt = '')
      fail NoMethodError, '#color_matrix method was removed, try #color_samples instead'
    end
  end
end
