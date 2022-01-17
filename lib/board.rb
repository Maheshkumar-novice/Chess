#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './modules/board-helper'
require_relative './modules/board-printer'

# Chess board
class Board
  include BoardHelper
  include BoardPrinter

  DEFAULT_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

  attr_reader :board

  def initialize(fen = DEFAULT_FEN)
    @board = create_board(fen)
  end

  def make_move(source, destination)
    @board[destination].piece = @board[source].piece
    @board[destination].piece.current_cell = destination
    @board[source].piece = nil
  end

  def moves_from_source(cell, color)
    piece = @board[cell].piece
    all_moves = piece.create_moves(board)
    moves_without_same_color_destination = reject_moves_of_same_color_destination(all_moves, color)
    moves_without_check_moves = reject_moves_that_keep_own_king_in_check(cell, moves_without_same_color_destination,
                                                                         color)
    piece.classify_moves(moves_without_check_moves, board)
  end
end
