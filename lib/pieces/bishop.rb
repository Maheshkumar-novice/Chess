#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'
require_relative '../components/creators/move-creator'
require_relative '../components/validators/move-classifier'

# Represents chess piece Bishop
class Bishop < Piece
  def initialize(move_creator: MoveCreator.new, move_classifier: MoveClassifier.new)
    super(move_creator, move_classifier)
  end

  def create_moves(board)
    @move_creator.bishop_moves(@current_cell, board)
  end

  def classify_moves(moves, board)
    @move_classifier.classify_moves(@color, moves, board)
  end

  def unicode
    @color == 'white' ? "\u2657" : "\u265D"
  end
end
