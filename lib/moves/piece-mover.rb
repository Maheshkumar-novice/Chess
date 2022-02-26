#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './special-moves'

# Piece moving operations
class PieceMover
  def initialize
    @special_moves = SpecialMoves.new
  end

  def move_piece(source, destination, board, meta_data, special_moves_state = {})
    return take_en_passant(source, destination, board, meta_data) if special_moves_state[:en_passant]
    return castling(source, destination, board, meta_data) if special_moves_state[:castling]

    regular_move(source, destination, board, meta_data)
  end

  def regular_move(source, destination, board, meta_data)
    pieces_going_to_change = { source => board[source].piece, destination => board[destination].piece }
    meta_data.update_changed_pieces_state(pieces_going_to_change)

    board[destination].update_piece_to(board[source].piece)
    board[destination].update_current_cell_of_piece(destination)
    board[source].update_piece_to(nil)
  end

  def take_en_passant(source, destination, board, meta_data)
    color = board[source].piece_color
    en_passant_capture_cell = @special_moves.en_passant_capture_cell(color, destination, board)
    pieces_going_to_change = { source => board[source].piece, destination => board[destination].piece,
                               en_passant_capture_cell => board[en_passant_capture_cell].piece }

    regular_move(source, destination, board, meta_data)
    board[en_passant_capture_cell].piece = nil
    meta_data.update_changed_pieces_state(pieces_going_to_change)
  end

  def castling(source, destination, board, meta_data)
    color = board[source].piece_color
    rook_source = @special_moves.rook_cell(color, destination)
    rook_destination = @special_moves.adjacent_move(destination, board)
    pieces_going_to_change = { source => board[source].piece,
                               destination => board[destination].piece,
                               rook_source => board[rook_source].piece,
                               rook_destination => board[rook_destination].piece }
    regular_move(source, destination, board, meta_data)
    regular_move(rook_source, rook_destination, board, meta_data)
    meta_data.update_changed_pieces_state(pieces_going_to_change)
  end
end
