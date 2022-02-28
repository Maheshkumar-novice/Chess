#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'

# Represents chess piece Pawn
class Pawn < Piece
  def create_moves(board)
    @move_creator.pawn_moves(@current_cell, color, board)
  end

  def classify_moves(moves, board, meta_data)
    @move_classifier.classify_pawn_moves(moves, board, meta_data, @current_cell, @color)
  end

  def unicode
    @color == 'white' ? "\u2659" : "\u265F"
  end
end
