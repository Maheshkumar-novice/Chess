#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../moves/piece-mover'

# Performs board operations
class BoardOperator
  attr_reader :board

  def initialize(board, meta_data, piece_mover: PieceMover.new)
    @board = board
    @meta_data = meta_data
    @moves = nil
    @piece_mover = piece_mover
  end

  def make_move(source, destination)
    special_moves_state = @meta_data.special_moves_state
    @meta_data.update(source, destination, board)
    @piece_mover.move_piece(source, destination, @board, @meta_data, special_moves_state)
  end

  def moves_from_source(source, color)
    @moves = @board[source].create_moves(@board)
    remove_allies(color)
    remove_moves_that_leads_to_check(source, color)
    @board[source].classify_moves(@moves, @board, @meta_data)
  end

  def king_in_check?(color)
    @board[find_king_position(color)].in_check?(@board)
  end

  def checkmate?(color)
    king_in_check?(color) && color_has_no_legal_moves?(color)
  end

  def stalemate?(color)
    !king_in_check?(color) && color_has_no_legal_moves?(color)
  end

  def color_has_no_legal_moves?(color)
    @board.each_key do |marker|
      next unless @board[marker].color?(color)

      moves = moves_from_source(marker, color)
      return false unless moves.values.all?(&:empty?)
    end
    true
  end

  def remove_allies(color)
    @moves.reject! { |move| @board[move].color?(color) }
  end

  def remove_moves_that_leads_to_check(source, color)
    @moves.reject! { |move| move_leads_to_check?(source, move, color) }
  end

  def find_king_position(king_color)
    @board.find { |_, cell| cell.piece_color == king_color && cell.piece_name.match?(/k/i) }.first
  end

  private

  def move_leads_to_check?(source, destination, color)
    @piece_mover.move_piece(source, destination, @board, @meta_data, @meta_data.special_moves_state)
    king_in_check = king_in_check?(color)
    revert_move
    king_in_check
  end

  def revert_move
    @meta_data.pieces_changed.each do |cell_marker, piece|
      @board[cell_marker].update_piece_to(piece)
      @board[cell_marker].update_current_cell_of_piece(cell_marker) if piece
    end
  end
end
