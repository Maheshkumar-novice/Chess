#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './components/move-generator'
require_relative './components/move-classifier'

# Rook
class Rook
  attr_accessor :name, :color, :current_cell

  def initialize(move_generator: MoveGenerator.new, move_classifier: MoveClassifier.new)
    @name = nil
    @color = nil
    @current_cell = nil
    @move_generator = move_generator
    @move_classifier = move_classifier
  end

  def create_moves(board)
    @move_generator.rook_moves(@current_cell, board)
  end

  def classify_moves(moves, board)
    @move_classifier.classify_moves(color, moves, board)
  end
end
