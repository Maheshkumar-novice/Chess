#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './utils/board-printer'
require_relative './cell'

# Chess board
class Board
  attr_reader :board

  def initialize(pieces, meta_data, printer: BoardPrinter.new)
    @pieces = pieces
    @meta_data = meta_data
    @printer = printer
    @rows = (1..8).to_a.reverse
    @columns = ('a'..'h').to_a
    @board = create_board
  end

  def print_board(source = [], empty = [], captures = [])
    @printer.print_board(@board, source, empty, captures)
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

  private

  def create_board
    board = {}
    @rows.each do |row|
      @columns.each do |column|
        cell_marker = create_cell_marker(row.to_s, column)
        board[cell_marker] = create_cell(row, column, @pieces.shift)
        board[cell_marker].piece.current_cell = cell_marker if board[cell_marker].piece
      end
    end
    board
  end

  def create_cell_marker(row, column)
    (column + row).to_sym
  end

  def create_cell(row, column, piece)
    cell = Cell.new
    cell.piece = piece
    cell.create_connections(row, column)
    cell
  end

  def reject_moves_of_same_color_destination(moves, color)
    moves.reject do |move|
      @board[move].piece&.color == color
    end
  end

  def reject_moves_that_keep_own_king_in_check(source, destinations, color)
    destinations.reject do |destination|
      move_leads_to_check?(source, destination, color)
    end
  end

  def move_leads_to_check?(source, destination, color)
    previous_source_piece = @board[source].piece
    previous_source_cell = previous_source_piece.current_cell
    previous_destination_piece = @board[destination].piece
    make_move(source, destination)
    king_in_check = @board[find_king_position(color)].piece.in_check?(@board)
    revert_move(source, destination, previous_source_piece, previous_source_cell, previous_destination_piece)
    king_in_check
  end

  def find_king_position(king_color)
    @board.each do |marker, cell|
      color = cell.piece&.color
      name = cell.piece&.name.to_s.downcase
      return marker if color == king_color && name == 'k'
    end
  end

  def revert_move(source, destination, previous_source_piece, previous_source_cell, previous_destination_piece)
    @board[source].piece = previous_source_piece
    @board[destination].piece = previous_destination_piece
    @board[source].piece.current_cell = previous_source_cell
  end
end
