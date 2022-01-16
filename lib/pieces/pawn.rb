#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../piece'

# Pawn
class Pawn < Piece
  def create_moves(board)
    return white_pawn_moves(board) if @color == 'white'
    return black_pawn_moves(board) if @color == 'black'
  end

  def classify_moves(moves, board)
    diagonal_moves = pawn_diagonal_moves(board[@current_cell]).select { |move| moves.include?(move) }
    remaining_moves = moves.reject { |move| diagonal_moves.include?(move) }

    { empty: find_empty_moves(remaining_moves, board), captures: find_capture_moves(diagonal_moves, board) }
  end

  private

  def white_pawn_moves(board)
    moves = generate_single_step_moves_from_directions(%i[column_above
                                                          top_left_diagonal
                                                          top_right_diagonal],
                                                       @current_cell, board)
    moves += add_double_step(board, :column_above) if @current_cell.match?(/^[a-h]2$/)
    moves
  end

  def black_pawn_moves(board)
    moves = generate_single_step_moves_from_directions(%i[column_below
                                                          bottom_left_diagonal
                                                          bottom_right_diagonal],
                                                       @current_cell, board)
    moves += add_double_step(board, :column_below) if @current_cell.match?(/^[a-h]7$/)
    moves
  end

  def add_double_step(board, step)
    step1 = board[@current_cell].send(step)
    step2 = board[step1].send(step) if !step1.nil? && board[step1].piece.nil?
    step2 ? [step2] : []
  end

  def create_captures(diagonal_moves, board)
    enemy_color = @color == 'white' ? 'black' : 'white'

    diagonal_moves.each_with_object([]) do |move, result|
      result << move if board[move].piece&.color == enemy_color
    end
  end

  def create_empty(moves, board)
    moves.each_with_object([]) do |move, result|
      result << move if board[move].piece.nil?
    end
  end

  def pawn_diagonal_moves(cell)
    [
      cell.top_right_diagonal,
      cell.top_left_diagonal,
      cell.bottom_right_diagonal,
      cell.bottom_left_diagonal
    ].compact
  end
end
