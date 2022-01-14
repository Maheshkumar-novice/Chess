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

  def moves(board); end

  def classified_moves(moves, board)
    enemy_color = @color == 'white' ? 'black' : 'white'

    moves.each_with_object(Hash.new { |h, k| h[k] = [] }) do |move, classified|
      classified[:empty] << move if board[move].piece.nil?
      classified[:captures] << move if board[move].piece&.color == enemy_color
    end
  end
end
