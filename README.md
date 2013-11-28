colorize
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

    String.colors - return array of all possible colors names
    String.modes  - return array of all possible modes
    String.color_matrix - displays color matrix with color names
    String.color_matrix("FOO") - display color matrix with "FOO" text

requirements
------------

* Win32/Console/ANSI (for Windows)

install
-------

* gem install colorize

*Note:* You may need to use sudo to install gems
