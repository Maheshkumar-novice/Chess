#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../piece'
require_relative '../modules/check'

# King
class King < Piece
  include Check

  def moves(board)
    generate_single_step_moves_from_directions(%i[row_right
                                                  row_left
                                                  column_above
                                                  column_below
                                                  top_left_diagonal
                                                  top_right_diagonal
                                                  bottom_right_diagonal
                                                  bottom_left_diagonal], @current_cell, board)
  end

  def in_check?(board)
    check_possibilities.any? do |check_possibility|
      send(check_possibility, @current_cell, board)
    end
  end
end
