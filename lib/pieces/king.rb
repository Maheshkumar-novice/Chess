#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'
require_relative '../moves/check-finder'

# Represents chess piece King
class King < Piece
  def initialize
    super
    @check_finder = CheckFinder.new
  end

  def create_moves(board)
    @move_creator.king_moves(@current_cell, board)
  end

  def in_check?(board)
    @check_finder.king_in_check?(@current_cell, board)
  end

  def unicode
    @color == 'white' ? "\u2654" : "\u265A"
  end
end
