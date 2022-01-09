#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './fen'
require_relative './modules/board-helper'
require_relative './modules/board-printer'
require_relative './modules/moves-generator'

# Chess board
class Board
  include BoardHelper
  include BoardPrinter
  include MovesGenerator

  DEFAULT_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

  def initialize(fen = DEFAULT_FEN)
    @pieces = Fen.new.to_pieces(fen)
    @rows = (1..8).to_a
    @columns = ('a'..'h').to_a
    @board = create_board
  end

  def create_board
    board = {}
    @rows.each do |row|
      @columns.each do |column|
        cell_marker = create_cell_marker(row, column)
        board[cell_marker] = create_cell(row, column)
      end
    end
    board
  end

  def make_move(source, destination)
    @board[destination].piece = @board[source].piece
    @board[source].piece = nil
  end

  def create_moves(cell)
    moves = []
    move_methods(@board[cell].piece.name).each { |method| moves += send(method, cell) }
    moves
  end
end
