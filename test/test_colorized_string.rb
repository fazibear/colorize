require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'minitest/autorun'
require File.dirname(__FILE__) + '/../lib/colorized_string'

class TestColorizedString < Minitest::Test
  def test_colorize_not_required
    assert_equal ''.respond_to?(:colorize),
                 false,
                 'Colorize should not be required. Only colorized_string'
  end

  def test_blue_symbol
    assert_equal ColorizedString['This is blue'].colorize(:blue),
                 "\e[0;34;49mThis is blue\e[0m"
  end

  def test_incorrect_symbol
    assert_equal ColorizedString['This is incorrect color'].colorize(:bold),
                 "\e[0;39;49mThis is incorrect color\e[0m"
  end

  def test_incorrect_hash
    assert_equal ColorizedString['This is incorrect color'].colorize(:color => :bold),
                 "\e[0;39;49mThis is incorrect color\e[0m"

    assert_equal ColorizedString['This is incorrect color'].colorize(:mode => :green),
                 "\e[0;39;49mThis is incorrect color\e[0m"

    assert_equal ColorizedString['This is incorrect color'].colorize(:background => :bold),
                 "\e[0;39;49mThis is incorrect color\e[0m"
  end

  def test_blue_hash
    assert_equal ColorizedString['This is also blue'].colorize(:color => :blue),
                 "\e[0;34;49mThis is also blue\e[0m"
  end

  def test_light_blue_symbol
    assert_equal ColorizedString['This is light blue'].colorize(:light_blue),
                 "\e[0;94;49mThis is light blue\e[0m"
  end

  def test_light_blue_with_red_background_hash
    assert_equal ColorizedString['This is light blue with red background'].colorize(:color => :light_blue, :background => :red),
                 "\e[0;94;41mThis is light blue with red background\e[0m"
  end

  def test_light_blue_with_red_background_symbol_and_hash
    assert_equal ColorizedString['This is light blue with red background'].colorize(:light_blue).colorize(:background => :red),
                 "\e[0;94;41mThis is light blue with red background\e[0m"
  end

  def test_blue_with_red_background_method
    assert_equal ColorizedString['This is blue text on red'].blue.on_red,
                 "\e[0;34;41mThis is blue text on red\e[0m"
  end

  def test_red_with_blue_background_symbol_and_method
    assert_equal ColorizedString['This is red on blue'].colorize(:red).on_blue,
                 "\e[0;31;44mThis is red on blue\e[0m"
  end

  def test_red_with_blue_background_and_underline_sumbol_and_methods
    assert_equal ColorizedString['This is red on blue and underline'].colorize(:red).on_blue.underline,
                 "\e[4;31;44mThis is red on blue and underline\e[0m"
  end

  def test_blue_with_red_background_and_blink_methods
    assert_equal ColorizedString['This is blue text on red'].blue.on_red.blink,
                 "\e[5;34;41mThis is blue text on red\e[0m"
  end

  def test_uncolorize
    assert_equal ColorizedString['This is uncolorized'].blue.on_red.uncolorize,
                 'This is uncolorized'
  end

  def test_colorized?
    assert_equal ColorizedString['Red'].red.colorized?, true
    assert_equal ColorizedString['Blue'].colorized?, false
    assert_equal ColorizedString['Green'].blue.green.uncolorize.colorized?, false
  end

  def test_concatenated__colorize?
    assert_equal ColorizedString["none #{ColorizedString['red'].red} none #{ColorizedString['blue'].blue} none"].colorized?, true
    assert_equal ColorizedString["none #{ColorizedString['red'].red} none #{ColorizedString['blue'].blue} none"].uncolorize.colorized?, false
  end

  def test_concatenated_strings_on_green
    assert_equal ColorizedString["none #{ColorizedString['red'].red} none #{ColorizedString['blue'].blue} none"].on_green,
                 "\e[0;39;42mnone \e[0m\e[0;31;42mred\e[0m\e[0;39;42m none \e[0m\e[0;34;42mblue\e[0m\e[0;39;42m none\e[0m"
  end

  def test_concatenated_strings_uncolorize
    assert_equal ColorizedString["none #{ColorizedString['red'].red} none #{ColorizedString['blue'].blue} none"].uncolorize,
                 'none red none blue none'
  end

  def test_frozen_strings
    assert_equal ColorizedString['This is blue text on red'].freeze.blue.on_red.blink,
                 "\e[5;34;41mThis is blue text on red\e[0m"
  end

  def test_new_line
    assert_equal ColorizedString["This is blue\ntext on red"].freeze.blue.on_red.blink,
                 "\e[5;34;41mThis is blue\ntext on red\e[0m"
  end

  def test_disable_colorization_with_=
    ColorizedString.disable_colorization = true
    assert_equal ColorizedString.disable_colorization, true
    ColorizedString.disable_colorization = false
  end

  def test_disable_colorization_with_method
    ColorizedString.disable_colorization true
    assert_equal ColorizedString.disable_colorization, true
    ColorizedString.disable_colorization false
  end

  def test_string_disable_colorization_with_=
    ColorizedString.disable_colorization = true

    assert_equal ColorizedString.disable_colorization, true

    assert_equal ColorizedString['This is blue after disabling'].blue,
                 'This is blue after disabling'

    ColorizedString.disable_colorization = false

    assert_equal ColorizedString['This is blue after enabling'].colorize(:blue),
                 "\e[0;34;49mThis is blue after enabling\e[0m"
  end

  def test_string_disable_colorization_with_method
    assert_equal ColorizedString['This is blue before disabling'].colorize(:blue),
                 "\e[0;34;49mThis is blue before disabling\e[0m"

    ColorizedString.disable_colorization true

    assert_equal ColorizedString.disable_colorization, true

    assert_equal ColorizedString['This is blue after disabling'].blue,
                 'This is blue after disabling'

    ColorizedString.disable_colorization false

    assert_equal ColorizedString['This is blue after enabling'].colorize(:blue),
                 "\e[0;34;49mThis is blue after enabling\e[0m"
  end

  def test_already_colored_string_with_one_value
    assert_equal ColorizedString["\e[31mThis is red\e[0m"].red,
                 ColorizedString['This is red'].red
  end

  def test_color_matrix_method
    assert_raises NoMethodError do
      ColorizedString.color_matrix
    end
  end

  def test_color_samples_method
    assert_output do
      ColorizedString.color_samples
    end
  end
end
