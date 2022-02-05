#!/usr/bin/env ruby
# frozen_string_literal: true

# Methods for coloring the given string in a standard way
module StringColorFormatter
  def print_info(str, ending: '', starting: '')
    print (starting + str + ending).green
  end

  def print_prompt(str, ending: '', starting: '')
    print (starting + str + ending).cyan
  end

  def print_error(str, ending: '', starting: '')
    print (starting + str + ending).red
  end

  def accent(str)
    str.yellow.bold
  end

  def gray_bold(str)
    str.gray.bold
  end

  def color_cell(str, bg_color)
    str.send(bg_color).black
  end
end
