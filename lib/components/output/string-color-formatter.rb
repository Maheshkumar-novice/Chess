#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './color'

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
end
