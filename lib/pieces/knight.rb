#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../piece'

# Knight
class Knight < Piece
  def create_moves(board)
    knight_moves(@current_cell, board)
  end
end
