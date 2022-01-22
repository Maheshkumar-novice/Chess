#!/usr/bin/env ruby
# frozen_string_literal: true

# Move Classifier
class MoveClassifier
  def classify_moves(color, moves, board)
    enemy_color = color == 'white' ? 'black' : 'white'

    result = { empty: [], captures: [] }
    moves.each_with_object(result) do |move, classified|
      classified[:empty] << move if board[move].empty?
      classified[:captures] << move if board[move].piece_color == enemy_color
    end
  end

  def classify_pawn_moves(moves, board, cell, color)
    diagonal_moves = pawn_diagonal_moves(board[cell]).select { |move| moves.include?(move) }
    remaining_moves = moves.reject { |move| diagonal_moves.include?(move) }

    { empty: empty(remaining_moves, board), captures: captures(diagonal_moves, board, color) }
  end

  private

  def pawn_diagonal_moves(cell)
    [cell.top_right_diagonal, cell.top_left_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal].compact
  end

  def captures(diagonal_moves, board, color)
    enemy_color = color == 'white' ? 'black' : 'white'

    diagonal_moves.each_with_object([]) { |move, result| result << move if board[move].piece_color == enemy_color }
  end

  def empty(moves, board)
    moves.each_with_object([]) { |move, result| result << move if board[move].empty? }
  end
end
