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

  def print_info_if(str, condition: true, ending: '', starting: '')
    print_info(str, ending: ending, starting: starting) if condition
  end

  def print_error_if(str, condition: true, ending: '', starting: '')
    print_error(str, ending: ending, starting: starting) if condition
  end

  def accent(str)
    str.yellow.bold
  end
end
