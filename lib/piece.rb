#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './modules/moves-generator'

# Chess - Piece
class Piece
  include MovesGenerator

  attr_accessor :name, :color, :current_cell

  def initialize
    @name = nil
    @color = nil
    @current_cell = nil
  end

  def create_moves(board); end

  def classify_moves(moves, board)
    enemy_color = @color == 'white' ? 'black' : 'white'

    result = {
      captures: [],
      empty: []
    }
    moves.each_with_object(result) do |move, classified|
      classified[:empty] << move if board[move].piece.nil?
      classified[:captures] << move if board[move].piece&.color == enemy_color
    end
  end
end
