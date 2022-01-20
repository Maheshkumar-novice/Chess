#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../utils/display'

# Cell Choice Maker
class CellChoiceMaker
  include Display

  def initialize
    @rows = ('1'..'8').to_a
    @columns = ('a'..'h').to_a
  end

  def bot_choice
    @rows.sample + @columns.sample
  end

  def human_choice
    print_prompt('Enter The Cell Coordinate (i.e. a1) > ')
    gets.chomp
  end
end
