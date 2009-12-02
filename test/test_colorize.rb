require File.dirname(__FILE__) + '/test_helper.rb'

class TestColorize < Test::Unit::TestCase
  def test_blue_symbol
    assert "This is blue".colorize(:blue) == "\e[0;34;49mThis is blue\e[0m"
  end

  def test_blue_hash
    assert "This is also blue".colorize( :color => :blue) == "\e[0;34;49mThis is also blue\e[0m"
  end

  def test_light_blue_symbol
    assert "This is light blue".colorize(:light_blue) == "\e[0;94;49mThis is light blue\e[0m"
  end

  def test_light_blue_with_red_background_hash
    assert "This is light blue with red background".colorize( :color => :light_blue, :background => :red ) == "\e[0;94;41mThis is light blue with red background\e[0m"
  end
 
  def test_light_blue_with_red_background_symbol_and_hash
    assert "This is light blue with red background".colorize( :light_blue ).colorize( :background => :red ) == "\e[0;144;41mThis is light blue with red background\e[0m"
  end
 
  def test_blue_with_red_background_method
    assert "This is blue text on red".blue.on_red == "\e[0;34;41mThis is blue text on red\e[0m"
  end

  def test_red_with_blue_background_symbol_and_method
    assert "This is red on blue".colorize( :red ).on_blue == "\e[0;31;44mThis is red on blue\e[0m"
  end

  def test_red_with_blue_background_and_underline_sumbol_and_methods
   assert "This is red on blue and underline".colorize( :red ).on_blue.underline == "\e[4;31;44mThis is red on blue and underline\e[0m"
  end

  def test_blue_with_red_background_and_blink_methods
    assert "This is blue text on red".blue.on_red.blink == "\e[5;34;41mThis is blue text on red\e[0m"
  end

  def test_uncolorize
    assert "This is uncolorized".blue.on_red.uncolorize == "This is uncolorized"
  end

  def test_colorized?
    assert "Red".red.colorized? == true
    assert "Blue".colorized? == false
    assert "Green".blue.green.uncolorize.colorized? == false
  end
end
