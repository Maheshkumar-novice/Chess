#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './components/move-generator'
require_relative './components/move-classifier'
require_relative './components/check-finder'

# King
class King
  attr_accessor :name, :color, :current_cell

  def initialize(move_generator: MoveGenerator.new, move_classifier: MoveClassifier.new, check_finder: CheckFinder.new)
    @name = nil
    @color = nil
    @current_cell = nil
    @move_generator = move_generator
    @move_classifier = move_classifier
    @check_finder = check_finder
  end

  def create_moves(board)
    @move_generator.king_moves(@current_cell, board)
  end

  def classify_moves(moves, board)
    @move_classifier.classify_moves(color, moves, board)
  end

  def in_check?(board)
    @check_finder.cell_in_check?(@current_cell, board)
  end

  def unicode
    @color == 'white' ? "\u2654" : "\u265A"
  end
end
