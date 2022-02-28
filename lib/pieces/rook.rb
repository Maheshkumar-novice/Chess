#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'

# Represents chess piece Rook
class Rook < Piece
  def create_moves(board)
    @move_creator.rook_moves(@current_cell, board)
  end

  def unicode
    @color == 'white' ? "\u2656" : "\u265C"
  end
end
