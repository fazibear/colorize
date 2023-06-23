# frozen_string_literal: true

require 'minitest/autorun'
require "#{File.dirname(__FILE__)}/../lib/colorize"
String.enable_readline_support = true

class TestColorize < Minitest::Test
  def test_blue_symbol
    assert_equal "\001\033[0;34;49m\002This is blue\001\033[0m\002", 'This is blue'.colorize(:blue)
  end

  def test_incorrect_symbol
    assert_equal "\001\033[0;39;49m\002This is incorrect color\001\033[0m\002",  'This is incorrect color'.colorize(:bold)
  end

  def test_incorrect_hash
    assert_equal "\001\033[0;39;49m\002This is incorrect color\001\033[0m\002", 'This is incorrect color'.colorize(:color => :bold)

    assert_equal "\001\033[0;39;49m\002This is incorrect color\001\033[0m\002", 'This is incorrect color'.colorize(:mode => :green)

    assert_equal "\001\033[0;39;49m\002This is incorrect color\001\033[0m\002", 'This is incorrect color'.colorize(:background => :bold)
  end

  def test_blue_hash
    assert_equal "\001\033[0;34;49m\002This is also blue?\001\033[0m\002", 'This is also blue?'.colorize(:color => :blue)
  end

  def test_light_blue_symbol
    assert_equal "\001\033[0;94;49m\002This is light blue\001\033[0m\002", 'This is light blue'.colorize(:light_blue)
  end

  def test_light_blue_with_red_background_hash
    assert_equal "\001\033[0;94;41m\002This is light blue with red background\001\033[0m\002", 'This is light blue with red background'.colorize(:color => :light_blue, :background => :red)
  end

  def test_light_blue_with_red_background_symbol_and_hash
    assert_equal "\001\033[0;94;41m\002This is light blue with red background\001\033[0m\002", 'This is light blue with red background'.colorize(:light_blue).colorize(:background => :red)
  end

  def test_blue_with_red_background_method
    assert_equal "\001\033[0;34;41m\002This is blue text on red\001\033[0m\002", 'This is blue text on red'.blue.on_red
  end

  def test_red_with_blue_background_symbol_and_method
    assert_equal "\001\033[0;31;44m\002This is red on blue\001\033[0m\002", 'This is red on blue'.colorize(:red).on_blue
  end

  def test_red_with_blue_background_and_underline_symbol_and_methods
    assert_equal "\001\033[4;31;44m\002This is red on blue and underline\001\033[0m\002", 'This is red on blue and underline'.colorize(:red).on_blue.underline
  end

  def test_blue_with_red_background_and_blink_methods
    assert_equal "\001\033[5;34;41m\002This is blue text on red\001\033[0m\002", 'This is blue text on red'.blue.on_red.blink
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
    assert_equal "\001\033[0;39;42m\002none \001\033[0m\002\001\033[0;31;42m\002red\001\033[0m\002\001\033[0;39;42m\002 none \001\033[0m\002\001\033[0;34;42m\002blue\001\033[0m\002\001\033[0;39;42m\002 none\001\033[0m\002", "none #{'red'.red} none #{'blue'.blue} none".on_green
  end

  def test_concatenated_strings_uncolorize
    assert_equal 'none red none blue none', "none #{'red'.red} none #{'blue'.blue} none".uncolorize
  end

  def test_new_line
    assert_equal "\001\033[5;34;41m\002This is blue\ntext on red\001\033[0m\002", "This is blue\ntext on red".blue.on_red.blink
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

    assert_equal "\001\033[0;34;49m\002This is blue after enabling\001\033[0m\002", 'This is blue after enabling'.colorize(:blue)
  end

  def test_string_disable_colorization_with_method
    assert_equal "\001\033[0;34;49m\002This is blue before disabling\001\033[0m\002", 'This is blue before disabling'.colorize(:blue)

    String.disable_colorization true

    assert String.disable_colorization

    assert_equal 'This is blue after disabling', 'This is blue after disabling'.blue

    String.disable_colorization false

    assert_equal "\001\033[0;34;49m\002This is blue after enabling\001\033[0m\002", 'This is blue after enabling'.colorize(:blue)
  end

  def test_already_colored_string_with_one_value
    assert_equal 'This is red'.red, "\001\033[31m\002This is red\001\033[0m\002".red
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
  end

  def test_add_color_alias_errors
    String.add_color_alias(:extra_red, :light_red)

    assert_raises ::Colorize::ColorAlreadyExist, 'Colorize: color :extra_red already exist!' do
      String.add_color_alias(:extra_red, :light_blue)
    end

    assert_raises ::Colorize::ColorDontExist, 'Colorize: color :light_color don\'t exist!' do
      String.add_color_alias(:extra_white, :light_color)
    end
  end

  def test_add_color_alias_with_single_hash
    String.add_color_alias(extra_green: :light_green)

    assert_equal 'example string'.light_green, 'example string'.extra_green
    assert_equal 'example string'.on_light_green, 'example string'.on_extra_green
  end

  def test_add_color_alias_with_single_hash_with_arrow
    String.add_color_alias(:extra_color => :gray)

    assert_equal 'example string'.gray, 'example string'.extra_color
    assert_equal 'example string'.on_gray, 'example string'.on_extra_color
  end

  def test_add_color_alias_with_multi_hash
    String.add_color_alias(extra_color_a: :gray, extra_color_b: :blue)

    assert_equal 'example string'.gray, 'example string'.extra_color_a
    assert_equal 'example string'.blue, 'example string'.extra_color_b
  end

  def test_add_color_alias_with_multi_hash_with_arrow
    String.add_color_alias(:extra_color_c => :gray, :extra_color_d => :blue)

    assert_equal 'example string'.gray, 'example string'.extra_color_c
    assert_equal 'example string'.on_blue, 'example string'.on_extra_color_d
  end

  def test_add_color_alias_with_multi_hash_mixed
    String.add_color_alias(extra_color_e: :gray, :extra_color_f => :blue)

    assert_equal 'example string'.gray, 'example string'.extra_color_e
    assert_equal 'example string'.on_blue, 'example string'.on_extra_color_f
  end

  def test_prevent_colors
    String.prevent_colors true

    assert String.prevent_colors
    assert_equal "#{'blue'.blue}#{'red'.red}#{'green'.green}", "#{'blue'.blue}red#{'green'.green}".red

    String.prevent_colors false
  end

  def test_colorized_string_without_readline
    assert_equal "\e[0;31;49mgreen\e[0m".green, 'green'.green
  end
end
