#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './components/move-generator'

# Pawn
class Pawn
  attr_accessor :name, :color, :current_cell

  def initialize(move_generator: MoveGenerator.new)
    @name = nil
    @color = nil
    @current_cell = nil
    @move_generator = move_generator
  end

  def create_moves(board)
    @move_generator.pawn_moves(@current_cell, color, board)
  end

  def classify_moves(moves, board)
    diagonal_moves = pawn_diagonal_moves(board[@current_cell]).select { |move| moves.include?(move) }
    remaining_moves = moves.reject { |move| diagonal_moves.include?(move) }

    { empty: find_empty_moves(remaining_moves, board), captures: find_capture_moves(diagonal_moves, board) }
  end

  private

  def pawn_diagonal_moves(cell)
    [
      cell.top_right_diagonal,
      cell.top_left_diagonal,
      cell.bottom_right_diagonal,
      cell.bottom_left_diagonal
    ].compact
  end

  def find_capture_moves(diagonal_moves, board)
    enemy_color = @color == 'white' ? 'black' : 'white'

    diagonal_moves.each_with_object([]) do |move, result|
      result << move if board[move].piece&.color == enemy_color
    end
  end

  def find_empty_moves(moves, board)
    moves.each_with_object([]) do |move, result|
      result << move if board[move].piece.nil?
    end
  end
end
