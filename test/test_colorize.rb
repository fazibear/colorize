# frozen_string_literal: true

require 'minitest/autorun'
require "#{File.dirname(__FILE__)}/../lib/colorize"

class TestColorize < Minitest::Test
  def test_blue_symbol
    assert_equal "\e[0;34;49mThis is blue\e[0m", 'This is blue'.colorize(:blue)
  end

  def test_incorrect_symbol
    assert_equal "\e[0;39;49mThis is incorrect color\e[0m",  'This is incorrect color'.colorize(:bold)
  end

  def test_incorrect_hash
    assert_equal "\e[0;39;49mThis is incorrect color\e[0m", 'This is incorrect color'.colorize(:color => :bold)

    assert_equal "\e[0;39;49mThis is incorrect color\e[0m", 'This is incorrect color'.colorize(:mode => :green)

    assert_equal "\e[0;39;49mThis is incorrect color\e[0m", 'This is incorrect color'.colorize(:background => :bold)
  end

  def test_blue_hash
    assert_equal "\e[0;34;49mThis is also blue\e[0m", 'This is also blue'.colorize(:color => :blue)
  end

  def test_light_blue_symbol
    assert_equal "\e[0;94;49mThis is light blue\e[0m", 'This is light blue'.colorize(:light_blue)
  end

  def test_light_blue_with_red_background_hash
    assert_equal "\e[0;94;41mThis is light blue with red background\e[0m", 'This is light blue with red background'.colorize(:color => :light_blue, :background => :red)
  end

  def test_light_blue_with_red_background_symbol_and_hash
    assert_equal "\e[0;94;41mThis is light blue with red background\e[0m", 'This is light blue with red background'.colorize(:light_blue).colorize(:background => :red)
  end

  def test_blue_with_red_background_method
    assert_equal "\e[0;34;41mThis is blue text on red\e[0m", 'This is blue text on red'.blue.on_red
  end

  def test_red_with_blue_background_symbol_and_method
    assert_equal "\e[0;31;44mThis is red on blue\e[0m", 'This is red on blue'.colorize(:red).on_blue
  end

  def test_red_with_blue_background_and_underline_symbol_and_methods
    assert_equal "\e[4;31;44mThis is red on blue and underline\e[0m", 'This is red on blue and underline'.colorize(:red).on_blue.underline
  end

  def test_blue_with_red_background_and_blink_methods
    assert_equal "\e[5;34;41mThis is blue text on red\e[0m", 'This is blue text on red'.blue.on_red.blink
  end

  def test_uncolorize
    assert_equal 'This is uncolorized', 'This is uncolorized'.blue.on_red.uncolorize
  end

  def test_colorized?
    assert_predicate 'Red'.red, :colorized?
    refute_predicate 'Blue', :colorized?
    refute_predicate 'Green'.blue.green.uncolorize, :colorized?
  end

  def test_concatenated__colorize?
    assert_predicate "none #{'red'.red} none #{'blue'.blue} none", :colorized?
    refute_predicate "none #{'red'.red} none #{'blue'.blue} none".uncolorize, :colorized?
  end

  def test_concatenated_strings_on_green
    assert_equal "\e[0;39;42mnone \e[0m\e[0;31;42mred\e[0m\e[0;39;42m none \e[0m\e[0;34;42mblue\e[0m\e[0;39;42m none\e[0m", "none #{'red'.red} none #{'blue'.blue} none".on_green
  end

  def test_concatenated_strings_uncolorize
    assert_equal 'none red none blue none', "none #{'red'.red} none #{'blue'.blue} none".uncolorize
  end

  def test_new_line
    assert_equal "\e[5;34;41mThis is blue\ntext on red\e[0m", "This is blue\ntext on red".blue.on_red.blink
  end

  def test_disable_colorization_with_=
    String.disable_colorization = true

    assert String.disable_colorization

    String.disable_colorization = false
  end

  def test_disable_colorization_with_method
    String.disable_colorization true

    assert String.disable_colorization

    String.disable_colorization false
  end

  def test_string_disable_colorization_with_=
    String.disable_colorization = true

    assert String.disable_colorization

    assert_equal 'This is blue after disabling', 'This is blue after disabling'.blue

    String.disable_colorization = false

    assert_equal "\e[0;34;49mThis is blue after enabling\e[0m", 'This is blue after enabling'.colorize(:blue)
  end

  def test_string_disable_colorization_with_method
    assert_equal "\e[0;34;49mThis is blue before disabling\e[0m", 'This is blue before disabling'.colorize(:blue)

    String.disable_colorization true

    assert String.disable_colorization

    assert_equal 'This is blue after disabling', 'This is blue after disabling'.blue

    String.disable_colorization false

    assert_equal "\e[0;34;49mThis is blue after enabling\e[0m", 'This is blue after enabling'.colorize(:blue)
  end

  def test_already_colored_string_with_one_value
    assert_equal 'This is red'.red, "\e[31mThis is red\e[0m".red
  end

  def test_color_matrix_method
    assert_raises NoMethodError do
      String.color_matrix
    end
  end

  def test_color_samples_method
    assert_output do
      String.color_samples
    end
  end

  def test_grey_alias
    assert_equal 'This is grey'.grey, 'This is grey'.light_black
  end

  def test_gray_alias
    assert_equal 'This is gray'.gray, 'This is gray'.light_black
  end

  def test_add_color_alias
    String.add_color_alias(:extra_blue, :light_blue)

    assert_equal 'blue'.light_blue, 'blue'.extra_blue
    assert_equal 'blue'.on_light_blue, 'blue'.on_extra_blue

    assert_raises ::Colorize::ColorAlreadyExist, 'Colorize: color :extra_blue already exist!' do
      String.add_color_alias(:extra_blue, :light_color)
    end

    assert_raises ::Colorize::ColorDontExist, 'Colorize: color :light_color don\'t exist!' do
      String.add_color_alias(:extra_white, :light_color)
    end
  end
end
