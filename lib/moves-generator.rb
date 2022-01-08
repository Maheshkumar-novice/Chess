#!/usr/bin/env ruby
# frozen_string_literal: true

# Moves Generator Class
class MovesGenerator
  def diagonal_moves(cell, board)
    moves = []
    diagonal_moves = %i[top_left_diagonal top_right_diagonal bottom_right_diagonal bottom_left_diagonal]
    diagonal_moves.each do |diagonal_move|
      moves += generate_moves(board[cell].send(diagonal_move), board, diagonal_move) if board[cell].send(diagonal_move)
    end
    moves
  end

  def horizontal_moves(cell, board)
    moves = []
    horizontal_moves = %i[row_right row_left]
    horizontal_moves.each do |horizontal_move|
      if board[cell].send(horizontal_move)
        moves += generate_moves(board[cell].send(horizontal_move), board,
                                horizontal_move)
      end
    end
    moves
  end

  def vertical_moves(cell, board)
    moves = []
    vertical_moves = %i[column_above column_below]
    vertical_moves.each do |vertical_move|
      if board[cell].send(vertical_move)
        moves += generate_moves(board[cell].send(vertical_move), board,
                                vertical_move)
      end
    end
    moves
  end

  def knight_moves(cell, board); end

  def pawn_moves(cell, board); end

  def king_moves(cell, board); end

  private

  def generate_moves(cell, board, direction, moves = [])
    return moves unless board[cell].piece.nil?

    if board[cell].send(direction).nil?
      moves << cell
      return moves
    end

    moves << cell
    next_cell = board[cell].send(direction)
    generate_moves(next_cell, board, direction, moves)
  end
end
