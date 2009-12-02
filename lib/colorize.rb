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
    
    :light_black    => 10,
    :light_red      => 11,
    :light_green    => 12,
    :light_yellow   => 13,
    :light_blue     => 14,
    :light_magenta  => 15,
    :light_cyan     => 16,
    :light_white    => 17
  }

  #
  # Modes Hash
  #
  MODES = {
    :default        => 0, # Turn off all attributes
    #:bright        => 1, # Set bright mode
    :underline      => 4, # Set underline mode
    :blink          => 5, # Set blink mode
    :swap           => 7, # Exchange foreground and background colors
    :hide           => 8  # Hide text (foreground color would be the same as background)
  }
  
  protected
  
  #
  # Set color values in new string intance
  #
  def set_color_parameters( params )
    if (params.instance_of?(Hash))
      @color = params[:color]
      @background = params[:background]
      @mode = params[:mode]
      @uncolorized = params[:uncolorized]
      self
    else
      nil
    end
  end
  
  public

  #
  # Change color of string
  #
  # Examples:
  #
  #   puts "This is blue".colorize( :blue )
  #   puts "This is light blue".colorize( :light_blue )
  #   puts "This is also blue".colorize( :color => :blue )
  #   puts "This is light blue with red background".colorize( :color => :light_blue, :background => :red )
  #   puts "This is light blue with red background".colorize( :light_blue ).colorize( :background => :red )
  #   puts "This is blue text on red".blue.on_red
  #   puts "This is red on blue".colorize( :red ).on_blue
  #   puts "This is red on blue and underline".colorize( :red ).on_blue.underline
  #   puts "This is blue text on red".blue.on_red.blink
  #   puts "This is uncolorized".blue.on_red.uncolorize
  #
  def colorize( params )
    return self unless STDOUT.isatty
    
    begin
      require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
    rescue LoadError
      raise 'You must gem install win32console to use colorize on Windows'
    end
    
    color_parameters = {}

    if (params.instance_of?(Hash))
      color_parameters[:color] = COLORS[params[:color]]
      color_parameters[:background] = COLORS[params[:background]]
      color_parameters[:mode] = MODES[params[:mode]]
    elsif (params.instance_of?(Symbol))
      color_parameters[:color] = COLORS[params]
    end
    
    color_parameters[:color] ||= @color ||= COLORS[:default]
    color_parameters[:background] ||= @background ||= COLORS[:default]
    color_parameters[:mode] ||= @mode ||= MODES[:default]

    color_parameters[:uncolorized] ||= @uncolorized ||= self.dup
   
    # calculate bright mode
    color_parameters[:color] += 50 if color_parameters[:color] > 10

    color_parameters[:background] += 50 if color_parameters[:background] > 10

    "\033[#{color_parameters[:mode]};#{color_parameters[:color]+30};#{color_parameters[:background]+40}m#{color_parameters[:uncolorized]}\033[0m".set_color_parameters( color_parameters )
  end

  #
  # Return uncolorized string
  #
  def uncolorize
    @uncolorized || self
  end
  
  #
  # Return true if sting is colorized
  #
  def colorized?
    !defined?(@uncolorized).nil?
  end

  #
  # Make some color and on_color methods
  #
  COLORS.each_key do | key |
    next if key == :default

    define_method key do
      self.colorize( :color => key )
    end
    
    define_method "on_#{key}" do
      self.colorize( :background => key )
    end
  end

  #
  # Methods for modes
  #
  MODES.each_key do | key |
    next if key == :default
    
    define_method key do
      self.colorize( :mode => key )
    end
  end

  class << self
    
    #
    # Return array of available modes used by colorize method
    #
    def modes
      keys = []
      MODES.each_key do | key |
        keys << key
      end
      keys
    end

    #
    # Return array of available colors used by colorize method
    #
    def colors
      keys = []
      COLORS.each_key do | key |
        keys << key
      end
      keys
    end 

    #
    # Display color matrix with color names.
    #
    def color_matrix( txt = "[X]" )
      size = String.colors.length
      String.colors.each do | color |
        String.colors.each do | back |
         print txt.colorize( :color => color, :background => back )
        end
        puts " < #{color}"
      end
      String.colors.reverse.each_with_index do | back, index |
        puts "#{"|".rjust(txt.length)*(size-index)} < #{back}"
      end 
      ""
    end
  end
end
