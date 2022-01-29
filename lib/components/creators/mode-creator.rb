#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../output/string-color-formatter'

# Creates game mode
class ModeCreator
  include StringColorFormatter

  def initialize
    @mode = nil
  end

  def choose_mode
    print_modes
    loop do
      @mode = mode_input
      return @mode if valid_mode?

      print_error('Enter a valid option!', ending: "\n")
    end
  end

  def valid_mode?
    @mode.match?(/^[a-d]{1}$/)
  end

  private

  def print_modes
    str = <<~MODES
      #{print_info(accent('Modes: '))}
        a. Bot vs Bot
        b. Bot vs Human
        c. Human vs Bot
        d. Human vs Human

      #{print_info("\n* First player gets the #{accent('white')} color", ending: "\n")}
    MODES
    print_info(str, ending: "\n")
  end

  def mode_input
    print_prompt('Enter Your Option [a, b, c, d] > ')
    gets.chomp
  end
end
