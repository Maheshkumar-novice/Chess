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
    @board[destination].update_piece_to(@board[source].piece)
    @board[destination].update_current_cell_of_piece(destination)
    @board[source].update_piece_to(nil)
  end

  def moves_from_source(source, color)
    @moves = @board[source].create_moves(@board)
    remove_allies(color)
    remove_moves_that_leads_to_check(source, color)
    @board[source].classify_moves(@moves, @board)
  end

  def king_in_check?(color)
    @board[find_king_position(color)].in_check?(@board)
  end

  private

  def remove_allies(color)
    @moves.reject! { |move| @board[move].color?(color) }
  end

  def remove_moves_that_leads_to_check(source, color)
    @moves.reject! { |move| move_leads_to_check?(source, move, color) }
  end

  def move_leads_to_check?(source, destination, color)
    store_current_move_state(source, destination)
    make_move(source, destination)
    king_in_check = king_in_check?(color)
    revert_move(source, destination)
    king_in_check
  end

  def find_king_position(king_color)
    @board.find { |_, cell| cell.piece_color == king_color && cell.piece_name.match?(/k/i) }.first
  end

  def store_current_move_state(source, destination)
    @previous_source_piece = @board[source].piece
    @previous_source_cell = @previous_source_piece.current_cell
    @previous_destination_piece = @board[destination].piece
  end

  def revert_move(source, destination)
    @board[source].update_piece_to(@previous_source_piece)
    @board[source].update_current_cell_of_piece(@previous_source_cell)
    @board[destination].update_piece_to(@previous_destination_piece)
  end
end
