#!/usr/bin/env ruby
# frozen_string_literal: true

# Moves Validator
module MovesValidator
  private

  def classify_moves_of_pawn(cell, moves, enemy_color, captures = [], empty = [])
    diagonal_moves = pawn_diagonal_moves(@board[cell]).select { |move| moves.include?(move) }
    diagonal_moves.each do |move|
      captures << move if capture?(move, enemy_color)
    end

    moves = moves.reject { |move| diagonal_moves.include?(move) }
    moves.each do |move|
      empty << move if empty?(move)
    end

    { empty: empty, captures: captures }
  end

  def pawn_diagonal_moves(cell)
    [
      cell.top_right_diagonal,
      cell.top_left_diagonal,
      cell.bottom_right_diagonal,
      cell.bottom_left_diagonal
    ].compact
  end

  def pawn?(cell)
    @board[cell].piece.name.downcase == 'p'
  end

  def empty?(move)
    @board[move].piece.nil?
  end

  def capture?(move, enemy_color)
    @board[move].piece&.color == enemy_color
  end
end
