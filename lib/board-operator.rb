#!/usr/bin/env ruby
# frozen_string_literal: true

# Chess board
class BoardOperator
  attr_reader :board

  def initialize(board, meta_data)
    @board = board
    @meta_data = meta_data
    @moves = nil
  end

  def make_move(source, destination)
    @board[destination].piece = @board[source].piece
    @board[destination].update_current_cell_of_piece(destination)
    @board[source].piece = nil
  end

  def moves_from_source(source, color)
    @moves = @board[source].create_moves(@board)
    reject_moves_of_same_color_destination(color)
    reject_moves_that_keep_own_king_in_check(source, color)
    @board[source].classify_moves(@moves, @board)
  end

  def king_in_check?(color)
    @board[find_king_position(color)].in_check?(@board)
  end

  private

  def reject_moves_of_same_color_destination(color)
    @moves.reject! { |move| @board[move].piece_color == color }
  end

  def reject_moves_that_keep_own_king_in_check(source, color)
    @moves.reject! { |move| move_leads_to_check?(source, move, color) }
  end

  def move_leads_to_check?(source, destination, color)
    previous_source_piece = @board[source].piece
    previous_source_cell = previous_source_piece.current_cell
    previous_destination_piece = @board[destination].piece
    make_move(source, destination)
    king_in_check = king_in_check?(color)
    revert_move(source, destination, previous_source_piece, previous_source_cell, previous_destination_piece)
    king_in_check
  end

  def revert_move(source, destination, previous_source_piece, previous_source_cell, previous_destination_piece)
    @board[source].piece = previous_source_piece
    @board[destination].piece = previous_destination_piece
    @board[source].update_current_cell_of_piece(previous_source_cell)
  end

  def find_king_position(king_color)
    @board.each do |marker, cell|
      next if cell.empty?

      color = cell.piece_color
      name = cell.piece_name
      return marker if color == king_color && name.match?(/k/i)
    end
  end
end
