#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../display/string-color-formatter'

# Creates cell choice
class CellChoiceCreator
  include StringColorFormatter

  def initialize
    @rows = ('1'..'8').to_a
    @columns = ('a'..'h').to_a
  end

  def bot_choice
    @columns.sample + @rows.sample
  end

  def human_choice
    print_prompt('Enter Your Choice > ')
    $stdin.gets.chomp
  end
end
