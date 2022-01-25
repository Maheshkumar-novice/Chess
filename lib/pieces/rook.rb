#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../components/creators/move-creator'
require_relative '../components/validators/move-classifier'
require_relative '../components/helpers/piece-helper'

# Rook
class Rook
  include PieceHelper

  attr_accessor :name, :color, :current_cell

  def initialize(move_creator: MoveCreator.new, move_classifier: MoveClassifier.new)
    @name = nil
    @color = nil
    @current_cell = nil
    @move_creator = move_creator
    @move_classifier = move_classifier
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
