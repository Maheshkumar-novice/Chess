#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './color'

# String Color Formatter
module StringColorFormatter
  def print_info(str, ending: '')
    print (str + ending).yellow
  end

  def print_info_if(str, condition: true, ending: '')
    print_info(str, ending: ending) if condition
  end

  def print_prompt(str, ending: '')
    print (str + ending).cyan
  end

  def print_error(str, ending: '')
    print (str + ending).red
  end

  def print_error_if(str, condition: true, ending: '')
    print_error(str, ending: ending) if condition
  end

  def accent(str)
    str.magenta.bold
  end
end
