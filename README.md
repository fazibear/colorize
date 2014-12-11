colorize [![Gem Version](https://badge.fury.io/rb/colorize.svg)](http://badge.fury.io/rb/colorize) [![Build Status](https://travis-ci.org/fazibear/colorize.svg?branch=master)](https://travis-ci.org/fazibear/colorize) [![Code Climate](https://codeclimate.com/github/fazibear/colorize/badges/gpa.svg)](https://codeclimate.com/github/fazibear/colorize)
========
  
Ruby String class extension. Adds methods to set text color, background color and, text effects on ruby console and command line output, using ANSI escape sequences.

features
--------
  
* change string color
* change string background
* change string effect

usage
-----

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
    puts "This is uncolorized".blue.on_red.uncolorize

Class methods:

    String.colors                       - return array of all possible colors names
    String.modes                        - return array of all possible modes
    String.color_samples                - displays color samples in all combinations
    String.disable_colorization         - check if colorization is disabled
    String.disable_colorization = false - disable colorization
    String.disable_colorization false   - disable colorization
    String.disable_colorization = true  - enable colorization
    String.disable_colorization true    - enable colorization

requirements
------------

* Win32/Console/ANSI (for Windows)

install
-------

* gem install colorize

*Note:* You may need to use sudo to install gems

license
-------

Copyright (C) 2007-2015 Michal Kalbarczyk

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
