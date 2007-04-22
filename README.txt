README for colorize
===================

Ruby string class extension. It add some methods to set color, background color and text effect on console easier using ANSI escape sequences.

Some usage samples:

  puts "This is blue".colorize( :blue )
  puts "This is light blue".colorize( :light_blue )
  puts "This is also blue".colorize( :color => :blue )
  puts "This is blue with red background".colorize( :color => :light_blue, :background => :red )
  puts "This is blue with red background".colorize( :light_blue ).colorize( :background => :red )
  puts "This is blue text on red".blue.on_red
  puts "This is red on blue".colorize( :red ).on_blue
  puts "This is uncolorized".blue.on_red.uncolorize

Class methods:

  String.colors - return array of all possible colors names
  String.modes  - return array of all possible modes
  String.color_matrix - displays color matrix with color names
  String.color_matrix( "FOO" ) - display color matrix with "FOO" text


