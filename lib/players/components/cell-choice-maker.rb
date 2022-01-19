#!/usr/bin/env ruby
# frozen_string_literal: true

# Cell Choice Maker
class CellChoiceMaker
  def initialize
    @rows = ('1'..'8').to_a
    @columns = ('a'..'h').to_a
  end

  def bot_choice
    @rows.sample + @columns.sample
  end

  def human_choice
    print 'Enter The Cell Coordinate (i.e. a1, b7, c3) > '
    gets.chomp
  end
end
