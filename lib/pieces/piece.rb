#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../moves/move-creator'
require_relative '../moves/move-classifier'

# Represents chess Piece
class Piece
  attr_accessor :name, :color, :current_cell

  def initialize
    @name = nil
    @color = nil
    @current_cell = nil
    @move_creator = MoveCreator.new
    @move_classifier = MoveClassifier.new
  end

  def classify_moves(moves, board, _meta_data = nil)
    @move_classifier.classify_moves(@color, moves, board)
  end

  def color?(color)
    @color == color
  end
end
