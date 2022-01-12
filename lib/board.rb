#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './fen'
require_relative './modules/board-helper'
require_relative './modules/board-printer'
require_relative './modules/moves-generator'
require_relative './modules/moves-validator'
require_relative './modules/check'

# Chess board
class Board
  include BoardHelper
  include BoardPrinter
  include MovesGenerator
  include MovesValidator
  include Check

  DEFAULT_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

  attr_reader :board

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

  def moves_from_source(cell, color)
    all_moves = create_moves(cell)
    moves_without_same_color = reject_moves_of_same_color(all_moves, color)
    moves_without_check_moves = eliminate_check_context_moves(cell, moves_without_same_color, color)
    classify_moves(cell, moves_without_check_moves)
  end

  def create_moves(cell)
    moves = []
    movements_of_piece(@board[cell].piece.name).each { |movement_method| moves += send(movement_method, cell) }
    moves
  end

  def eliminate_check_context_moves(source, destinations, color)
    destinations.reject do |destination|
      move_leads_to_check?(source, destination, color)
    end
  end

  def classify_moves(cell, moves)
    enemy_color = @board[cell].piece.color == 'white' ? 'black' : 'white'
    return classify_moves_of_pawn(cell, moves, enemy_color) if pawn?(cell)

    captures = []
    empty = []
    moves.each do |move|
      empty << move if empty?(move)
      captures << move if capture?(move, enemy_color)
    end

    { empty: empty, captures: captures }
  end
end
