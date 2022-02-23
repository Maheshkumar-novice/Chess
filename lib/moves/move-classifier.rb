#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './special-moves'

# Classifies the given moves as empty & captures
class MoveClassifier
  def initialize
    @enemy_color = nil
    @diagonal_moves = nil
    @moves_without_diagonal_moves = nil
    @special_moves = SpecialMoves.new
  end

  def classify_moves(color, moves, board)
    create_enemy_color(color)

    result = { empty: [], captures: [] }
    moves.each_with_object(result) do |move, classified|
      classified[:empty] << move if board[move].empty?
      classified[:captures] << move if board[move].color?(@enemy_color)
    end
  end

  def classify_pawn_moves(moves, board, meta_data, cell, color)
    filter_moves(moves, board, cell)
    create_enemy_color(color)
    { empty: empty(board), captures: captures(board, meta_data, color, cell) }
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

  def empty(board)
    @moves_without_diagonal_moves.each_with_object([]) { |move, result| result << move if board[move].empty? }
  end

  def captures(board, meta_data, _color, cell)
    @diagonal_moves.each_with_object([]) do |move, result|
      next result << move if board[move].color?(@enemy_color)

      result << move if @special_moves.en_passant?(cell, move, board, meta_data)
    end
  end
end
