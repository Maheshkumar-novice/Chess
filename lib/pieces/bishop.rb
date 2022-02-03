#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'

# Represents chess piece Bishop
class Bishop < Piece
  def initialize(move_creator: MoveCreator.new, move_classifier: MoveClassifier.new)
    super(move_creator, move_classifier)
  end

  def create_moves(board)
    @move_creator.bishop_moves(@current_cell, board)
  end

  def unicode
    @color == 'white' ? "\u2657" : "\u265D"
  end
end
