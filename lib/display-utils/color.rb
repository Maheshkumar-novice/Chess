#!/usr/bin/env ruby
# frozen_string_literal: true

# https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal

# String class extension for coloring
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def black
    colorize(30)
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def magenta
    colorize(35)
  end

  def cyan
    colorize(36)
  end

  def gray
    colorize(37)
  end

  def bg_black
    colorize(40)
  end

  def bg_red
    colorize(41)
  end

  def bg_green
    colorize(42)
  end

  def bg_yellow
    colorize(43)
  end

  def bg_blue
    colorize(44)
  end

  def bg_magenta
    colorize(45)
  end

  def bg_cyan
    colorize(46)
  end

  def bg_gray
    colorize(47)
  end

  def bold
    "\e[1m#{self}\e[22m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end
