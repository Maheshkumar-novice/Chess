#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'
require_relative '../components/creators/move-creator'
require_relative '../components/validators/move-classifier'

# Represents chess piece Rook
class Rook < Piece
  def initialize(move_creator: MoveCreator.new, move_classifier: MoveClassifier.new)
    super(move_creator, move_classifier)
  end

  def create_moves(board)
    @move_creator.rook_moves(@current_cell, board)
  end

  def classify_moves(moves, board)
    @move_classifier.classify_moves(@color, moves, board)
  end

  def unicode
    @color == 'white' ? "\u2656" : "\u265C"
  end
end
