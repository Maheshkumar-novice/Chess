#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './special-moves'

# Piece moving operations
class PieceMover
  def initialize(special_moves = SpecialMoves.new)
    @special_moves = special_moves
  end

  def move_piece(source, destination, board, meta_data)
    return take_en_passant(source, destination, board, meta_data) if @special_moves.en_passant?(source, destination,
                                                                                                board, meta_data)

    regular_move(source, destination, board)
  end

  def regular_move(source, destination, board)
    board[destination].update_piece_to(board[source].piece)
    board[destination].update_current_cell_of_piece(destination)
    board[source].update_piece_to(nil)
  end

  def take_en_passant(source, destination, board)
    color = board[source].piece_color
    regular_move(source, destination, board)
    board[@special_moves.en_passant_capture_cell(color, destination, board)].piece = nil
  end
end
