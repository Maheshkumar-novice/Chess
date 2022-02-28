#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'

# Represents chess piece Queen
class Queen < Piece
  def create_moves(board)
    @move_creator.queen_moves(@current_cell, board)
  end

  def unicode
    @color == 'white' ? "\u2655" : "\u265B"
  end
end
