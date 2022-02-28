#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'

# Represents chess piece Bishop
class Bishop < Piece
  def create_moves(board)
    @move_creator.bishop_moves(@current_cell, board)
  end

  def unicode
    @color == 'white' ? "\u2657" : "\u265D"
  end
end
