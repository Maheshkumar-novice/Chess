#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents chess piece Pawn
class Pawn
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
    @move_creator.pawn_moves(@current_cell, color, board)
  end

  def classify_moves(moves, board)
    @move_classifier.classify_pawn_moves(moves, board, @current_cell, @color)
  end

  def unicode
    @color == 'white' ? "\u2659" : "\u265F"
  end
end
