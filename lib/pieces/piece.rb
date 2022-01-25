#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents chess Piece
class Piece
  attr_accessor :name, :color, :current_cell

  def initialize(move_creator, move_classifier)
    @name = nil
    @color = nil
    @current_cell = nil
    @move_creator = move_creator
    @move_classifier = move_classifier
  end

  def color?(color)
    @color == color
  end
end
