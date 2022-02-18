#!/usr/bin/env ruby
# frozen_string_literal: true

# Special Moves
class SpecialMoves
  def en_passant?(source, destination, board, meta_data)
    board[source].piece_name.downcase == 'p' && meta_data.en_passant_move == destination
  end

  def en_passant_capture_cell(destination, board)
    return board[destination].column_below if board[destination].piece_color == 'white'

    board[destination].column_above
  end
end
