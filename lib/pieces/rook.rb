#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../piece'

# Rook
class Rook < Piece
  def moves(board)
    generate_all_moves_from_directions(%i[row_right
                                          row_left
                                          column_above
                                          column_below],
                                       @current_cell, board)
  end
end
