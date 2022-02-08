#!/usr/bin/env ruby
# frozen_string_literal: true

# Piece moving operations
class PieceMover
  def move_piece(source, destination, board, meta_data)
    return take_en_passant(source, destination, board, meta_data) if en_passant?(source, destination, board, meta_data)

    regular_move(source, destination, board)
  end

  def regular_move(source, destination, board)
    board[destination].update_piece_to(board[source].piece)
    board[destination].update_current_cell_of_piece(destination)
    board[source].update_piece_to(nil)
  end

  def take_en_passant(source, destination, board)
    regular_move(source, destination, board)
    board[en_passant_capture_cell(source, destination, board)] = nil
  end

  def en_passant?(source, destination, board, meta_data)
    board[source].piece_name.downcase == 'p' && meta_data.en_passant_move == destination
  end

  def en_passant_capture_cell(source, destination, board)
    return board[destination].column_below if board[source].piece_color == 'white'

    board[destination].column_above
  end
end
