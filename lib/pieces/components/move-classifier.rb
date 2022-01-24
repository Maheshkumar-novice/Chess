#!/usr/bin/env ruby
# frozen_string_literal: true

# Move Classifier
class MoveClassifier
  def initialize
    @enemy_color = nil
    @diagonal_moves = nil
    @moves_without_diagonal_moves = nil
  end

  def classify_moves(color, moves, board)
    create_enemy_color(color)

    result = { empty: [], captures: [] }
    moves.each_with_object(result) do |move, classified|
      classified[:empty] << move if board[move].empty?
      classified[:captures] << move if board[move].enemy?(@enemy_color)
    end
  end

  def classify_pawn_moves(moves, board, cell, color)
    filter_moves(moves, board, cell)
    create_enemy_color(color)
    { empty: empty(board), captures: captures(board) }
  end

  private

  def create_enemy_color(color)
    @enemy_color = color == 'white' ? 'black' : 'white'
  end

  def filter_moves(moves, board, cell)
    @diagonal_moves = pawn_diagonal_moves(board[cell]).select { |move| moves.include?(move) }
    @moves_without_diagonal_moves = moves.reject { |move| @diagonal_moves.include?(move) }
  end

  def pawn_diagonal_moves(cell)
    cell.diagonals.compact
  end

  def captures(board)
    @diagonal_moves.each_with_object([]) { |move, result| result << move if board[move].enemy?(@enemy_color) }
  end

  def empty(board)
    @moves_without_diagonal_moves.each_with_object([]) { |move, result| result << move if board[move].empty? }
  end
end
