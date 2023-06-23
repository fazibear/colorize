# frozen_string_literal: true

module Colorize
  module InstanceMethods
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
      return self if self.class.disable_colorization

      scan_for_colors.inject(self.class.new) do |str, match|
        colors_from_params(match, params)
        defaults_colors(match)
        str << colorized_string(match[0], match[1], match[2], match[3])
      end
    end

    #
    # Return uncolorized string
    #
    def uncolorize
      scan_for_colors.inject(self.class.new) do |str, match|
        str << match[3]
      end
    end

    #
    # Return true if string is colorized
    #
    def colorized?
      scan_for_colors.inject([]) do |colors, match|
        colors << match.tap(&:pop)
      end.flatten.compact.any?
    end

    private

    #
    # Generate string with escape colors
    #
    def colorized_string(mode, color, background_color, previous)
      if self.class.enable_readline_support
        "\001\033[#{mode};#{color};#{background_color}m\002#{previous}\001\033[0m\002"
      else
        "\033[#{mode};#{color};#{background_color}m#{previous}\033[0m"
      end
    end

    #
    # Set default colors
    #
    def defaults_colors(match)
      match[0] ||= mode(:default)
      match[1] ||= color(:default)
      match[2] ||= background_color(:default)
    end

    #
    # Set color from params
    #
    def colors_from_params(match, params)
      case params
      when Hash then colors_from_hash(match, params)
      when Symbol then color_from_symbol(match, params)
      end
    end

    #
    # Set colors from params hash
    #
    def colors_from_hash(match, hash)
      if self.class.prevent_colors
        match[0] ||= mode(hash[:mode])                   if mode(hash[:mode])
        match[1] ||= color(hash[:color])                 if color(hash[:color])
        match[2] ||= background_color(hash[:background]) if background_color(hash[:background])
      else
        match[0] = mode(hash[:mode])                   if mode(hash[:mode])
        match[1] = color(hash[:color])                 if color(hash[:color])
        match[2] = background_color(hash[:background]) if background_color(hash[:background])
      end
    end

    #
    # Set color from params symbol
    #
    def color_from_symbol(match, symbol)
      if self.class.prevent_colors && color(symbol)
        match[1] ||= color(symbol)
      else
        match[1] = color(symbol)
      end
    end

    #
    # Color for foreground
    #
    def color(color)
      self.class.color_codes[color]
    end

    #
    # Color for background (offset 10)
    #
    def background_color(color)
      self.class.color_codes[color] + 10 if self.class.color_codes[color]
    end

    #
    # Mode
    #
    def mode(mode)
      self.class.mode_codes[mode]
    end

    #
    # Generate regex for color scanner
    #
    def scan_for_colors_regex
      if self.class.enable_readline_support
        /\001?\033\[([0-9;]+)m\002?(.+?)\001?\033\[0m\002?|([^\001\033]+)/m
      else
        /\033\[([0-9;]+)m(.+?)\033\[0m|([^\033]+)/m
      end
    end

    #
    # Scan for colorized string
    #
    def scan_for_colors
      scan(scan_for_colors_regex).map do |match|
        split_colors(match)
      end
    end

    def split_colors(match)
      colors = (match[0] || '').split(';')
      array = Array.new(3)
      array[0], array[1], array[2] = colors if colors.length == 3
      array[1] = colors                     if colors.length == 1
      array[3] = match[1] || match[2]
      array
    end

    #
    # Require windows libs
    #
    def require_windows_libs
      require 'Win32/Console/ANSI' if RUBY_VERSION < '2.0.0' && RUBY_PLATFORM.include?('win32')
    rescue LoadError
      raise 'You must gem install win32console to use colorize on Windows'
    end
  end
end
