#
# Colorize String class extension.
#
class String

  #
  # Colors Hash
  #
  COLORS = {
    :black   => 0, :light_black    => 60,
    :red     => 1, :light_red      => 61,
    :green   => 2, :light_green    => 62,
    :yellow  => 3, :light_yellow   => 63,
    :blue    => 4, :light_blue     => 64,
    :magenta => 5, :light_magenta  => 65,
    :cyan    => 6, :light_cyan     => 66,
    :white   => 7, :light_white    => 67,
    :default => 9
  }

  #
  # Modes Hash
  #
  MODES = {
    :default   => 0, # Turn off all attributes
    :bold      => 1, # Set bold mode
    :underline => 4, # Set underline mode
    :blink     => 5, # Set blink mode
    :swap      => 7, # Exchange foreground and background colors
    :hide      => 8  # Hide text (foreground color would be the same as background)
  }

  #
  # Color for foreground (offset 30)
  #
  def color(color)
    COLORS[color] + 30
  end

  #
  # Color for background (offset 40)
  #
  def background_color(color)
    COLORS[color] + 40
  end

  #
  # Mode
  #
  def mode(mode)
    MODES[mode]
  end

  def scan_for_colors
    scan(/\033\[([0-9]+);([0-9]+);([0-9]+)m(.+?)\033\[0m|([^\033]+)/m)
  end

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
    scan_for_colors.inject('') do |str, match|
      set_defaults(match)
      set_from_params(match, params)
      str << "\033[#{match[0]};#{match[1]};#{match[2]}m#{match[3]}\033[0m"
    end
  end

  #
  # Return uncolorized string
  #
  def uncolorize
    scan_for_colors.inject('') do |str, match|
      str << (match[3] || match[4])
    end
  end

  #
  # Return true if string is colorized
  #
  def colorized?
    scan_for_colors.reject(&:last).any?
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
    match[0] ||= mode(:default)
    match[1] ||= color(:default)
    match[2] ||= background_color(:default)
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
    match[0] = mode(hash[:mode]) if hash[:mode] && MODES[hash[:mode]]
    match[1] = color(hash[:color]) if hash[:color] && COLORS[hash[:color]]
    match[2] = background_color(hash[:background]) if hash[:background] && COLORS[hash[:background]]
  end

  #
  # Set color from params symbol
  #
  def set_from_symbol(match, symbol)
    match[1] = color(symbol) if symbol && COLORS[symbol]
  end

  class << self
    #
    # Display color samples
    #
    def color_samples
      colors.permutation(2).each do |background, color|
        sample_text = "#{color.inspect.rjust(15)} on #{background.inspect.ljust(15)}"
        puts "#{sample_text.colorize(:color => color, :background => background)} #{sample_text}"
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
