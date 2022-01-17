#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './player'

# Bot Player
class Bot < Player
  COLUMNS = ('a'..'h').to_a

  def input
    row = random_row
    column = random_column
    (column + row).to_sym
  end

  private

  def random_row
    rand(1..8).to_s
  end

  def random_column
    COLUMNS.sample
  end
end
