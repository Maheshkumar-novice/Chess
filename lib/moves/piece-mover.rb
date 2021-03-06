#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../special-moves/castling/castling'
require_relative '../special-moves/en-passant/en-passant'

# Piece moving operations
class PieceMover
  def initialize
    @castling = Castling.new
    @en_passant = EnPassant.new
  end

  def move_piece(source, destination, board, meta_data, special_moves_state = {})
    return take_en_passant(source, destination, board, meta_data) if special_moves_state[:en_passant]
    return castling(source, destination, board, meta_data) if special_moves_state[:castling]

    regular_move(source, destination, board, meta_data)
  end

  def regular_move(source, destination, board, meta_data)
    pieces_going_to_change = { source => board[source].piece, destination => board[destination].piece }

    board[destination].update_piece_to(board[source].piece)
    board[destination].update_current_cell_of_piece(destination)
    board[source].update_piece_to(nil)

    meta_data.update_changed_pieces_state(pieces_going_to_change)
  end

  def take_en_passant(source, destination, board, meta_data)
    en_passant_capture_cell = @en_passant.en_passant_capture_cell(board[source].piece_color, destination, board)
    pieces_going_to_change = { source => board[source].piece, destination => board[destination].piece,
                               en_passant_capture_cell => board[en_passant_capture_cell].piece }

    regular_move(source, destination, board, meta_data)
    board[en_passant_capture_cell].update_piece_to(nil)

    meta_data.update_changed_pieces_state(pieces_going_to_change)
  end

  def castling(source, destination, board, meta_data)
    rook_source = @castling.rook_cell(board[source].piece_color, destination)
    rook_destination = @castling.adjacent_move(destination, board)
    pieces_going_to_change = { source => board[source].piece,
                               destination => board[destination].piece,
                               rook_source => board[rook_source].piece,
                               rook_destination => board[rook_destination].piece }

    regular_move(source, destination, board, meta_data)
    regular_move(rook_source, rook_destination, board, meta_data)

    meta_data.update_changed_pieces_state(pieces_going_to_change)
  end
end
