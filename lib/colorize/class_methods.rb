# frozen_string_literal: true

module Colorize
  module ClassMethods
    @@color_codes ||= {
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

    @@mode_codes ||= {
      :default   => 0, # Turn off all attributes
      :bold      => 1, # Set bold mode
      :italic    => 3, # Set italic mode
      :underline => 4, # Set underline mode
      :blink     => 5, # Set blink mode
      :swap      => 7, # Exchange foreground and background colors
      :hide      => 8  # Hide text (foreground color would be the same as background)
    }

    #
    # Property to disable colorization
    #
    def disable_colorization(value = nil)
      if value.nil?
        if defined?(@@disable_colorization)
          @@disable_colorization || false
        else
          false
        end
      else
        @@disable_colorization = (value || false)
      end
    end

    #
    # Setter for disable colorization
    #
    def disable_colorization=(value)
      @@disable_colorization = (value || false)
    end

    #
    # Return array of available colors used by colorize
    #
    def colors
      color_codes.keys
    end

    #
    # Return array of available modes used by colorize
    #
    def modes
      mode_codes.keys
    end

    #
    # Display color samples
    #
    def color_samples
      colors.permutation(2).each do |background, color|
        sample_text = "#{color.inspect.rjust(15)} on #{background.inspect.ljust(15)}"
        puts "#{new(sample_text).colorize(:color => color, :background => background)} #{sample_text}"
      end
    end

    #
    # Method removed, raise NoMethodError
    #
    def color_matrix(_ = '')
      fail NoMethodError, '#color_matrix method was removed, try #color_samples instead'
    end

    # private

    #
    # Color codes hash
    #
    def color_codes
      @@color_codes
    end

    def add_color_code(code, color)
      @@color_codes[code] = color
    end

    #
    # Mode codes hash
    #
    def mode_codes
      @@mode_codes
    end

    #
    # Generate color and on_color methods
    #
    def color_methods
      colors.each do |key|
        next if key == :default

        add_color_method(key)
      end
    end

    #
    # Generate color and on_color method
    #
    def add_color_method(key)
      define_method key do
        colorize(:color => key)
      end

      define_method "on_#{key}" do
        colorize(:background => key)
      end
    end

    #
    # Generate modes methods
    #
    def modes_methods
      modes.each do |key|
        next if key == :default

        define_method key do
          colorize(:mode => key)
        end
      end
    end

    #
    # Add color alias
    #
    def add_color_alias(_alias_, _color_)
      color_codes[_alias_] && fail(::Colorize::ColorAlreadyExist, "Colorize: color named :#{_alias_} already exist!")
      color = color_codes[_color_] || fail(::Colorize::ColorDontExist, "Colorize: color :#{_color_} don't exist!")
      add_color_code(_alias_, color)
      add_color_method(_alias_)
    end
  end
end
