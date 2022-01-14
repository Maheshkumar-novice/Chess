#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../piece'

# Bishop
class Bishop < Piece
  def moves(board)
    generate_all_moves_from_directions(%i[top_left_diagonal
                                          top_right_diagonal
                                          bottom_right_diagonal
                                          bottom_left_diagonal],
                                       @current_cell, board)
  end
end
