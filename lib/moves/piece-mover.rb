#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './special-moves'

# Piece moving operations
class PieceMover
  def initialize(special_moves = SpecialMoves.new)
    @special_moves = special_moves
    @pieces_going_to_change = {}
  end

  def move_piece(source, destination, board, meta_data, special_moves_state = {})
    return take_en_passant(source, destination, board, meta_data) if special_moves_state[:en_passant]

    regular_move(source, destination, board, meta_data)
  end

  def regular_move(source, destination, board, meta_data)
    @pieces_going_to_change = { source => board[source].piece, destination => board[destination].piece }
    meta_data.update_changed_pieces_state(@pieces_going_to_change)
    board[destination].update_piece_to(board[source].piece)
    board[destination].update_current_cell_of_piece(destination)
    board[source].update_piece_to(nil)
  end

  def take_en_passant(source, destination, board, meta_data)
    color = board[source].piece_color
    en_passant_capture_cell = @special_moves.en_passant_capture_cell(color, destination, board)
    en_passant_capture_cell_piece = board[en_passant_capture_cell].piece
    regular_move(source, destination, board, meta_data)
    board[en_passant_capture_cell].piece = nil
    @pieces_going_to_change[en_passant_capture_cell] = en_passant_capture_cell_piece
    meta_data.update_changed_pieces_state(@pieces_going_to_change)
  end
end
