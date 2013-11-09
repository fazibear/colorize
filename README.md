[![Gem Version](https://badge.fury.io/rb/colorize.png)](http://badge.fury.io/rb/colorize)
# Colorize
  
Ruby String class extension. Adds methods to set text color, background color and, text effects on ruby console and command line output, using ANSI escape sequences.

## Features
  
* Change string color
* Change string background
* Change string effect

## Install

    gem install colorize

*Note:* You may need to use sudo to install gems

## Usage

Some usage samples:

    puts "This is blue".colorize(:blue)
    puts "This is light blue".colorize(:light_blue)
    puts "This is also blue".colorize(:color => :blue)
    puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)
    puts "This is light blue with red background".colorize(:light_blue ).colorize( :background => :red)
    puts "This is blue text on red".blue.on_red
    puts "This is red on blue".colorize(:red).on_blue
    puts "This is red on blue and underline".colorize(:red).on_blue.underline
    puts "This is blue text on red".blue.on_red.blink
    puts "This is uncolored".blue.on_red.uncolorize

    #Class methods

    String.colors				# return array of all possible colors names
    String.modes				# return array of all possible modes
    String.color_matrix			# displays color matrix with color names
    String.color_matrix("FOO")	# display color matrix with "FOO" text

## Requirements

* Win32/Console/ANSI (for Windows)


## License

colorize - Ruby String class extension. Adds methods to set text color, background color and, text effects on ruby console and command line output, using ANSI escape sequences.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANT ABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, 51 Franklin Street, Suite 500 Boston, MA 02110-1335, USA 

Copyright (C) 2013 Michal Kalbarczyk
