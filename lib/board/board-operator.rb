#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../moves/piece-mover'
require_relative '../special-moves/castling/castling'

# Performs board operations
class BoardOperator
  attr_reader :board, :meta_data

  def initialize(board, meta_data)
    @board = board
    @meta_data = meta_data
    @moves = nil
    @piece_mover = PieceMover.new
    @castling = Castling.new
  end

  def make_move(source, destination)
    special_moves_state = @meta_data.special_moves_state(@board, source, destination, @moves)
    @meta_data.update(source, destination, board)
    @piece_mover.move_piece(source, destination, @board, @meta_data, special_moves_state)
  end

  def moves_from_source(source, color)
    @moves = @board[source].create_moves(@board)
    remove_allies(color)
    remove_moves_that_leads_to_check(source, color)
    add_castling_move(source, color) if @board[source].king?
    @board[source].classify_moves(@moves, @board, @meta_data)
  end

  def remove_allies(color)
    @moves.reject! { |move| @board[move].piece_color?(color) }
  end

  def remove_moves_that_leads_to_check(source, color)
    @moves.reject! { |move| move_leads_to_check?(source, move, color) }
  end

  def move_leads_to_check?(source, destination, color)
    special_moves_state = @meta_data.special_moves_state(@board, source, destination, @moves)
    @piece_mover.move_piece(source, destination, @board, @meta_data, special_moves_state)
    king_in_check = king_in_check?(color)
    revert_move
    king_in_check
  end

  def king_in_check?(color)
    @board[find_king_position(color)].in_check?(@board)
  end

  def find_king_position(king_color)
    @board.find { |_, cell| cell.piece_color == king_color && cell.piece_name.match?(/k/i) }.first
  end

  def revert_move
    @meta_data.pieces_changed.each do |cell_marker, piece|
      @board[cell_marker].update_piece_to(piece)
      @board[cell_marker].update_current_cell_of_piece(cell_marker) if piece
    end
  end

  def checkmate?(color)
    king_in_check?(color) && color_has_no_legal_moves?(color)
  end

  def stalemate?(color)
    !king_in_check?(color) && color_has_no_legal_moves?(color)
  end

  def color_has_no_legal_moves?(color)
    @board.each_key do |marker|
      next unless @board[marker].piece_color?(color)

      moves = moves_from_source(marker, color)
      return false unless moves.values.all?(&:empty?)
    end
    true
  end

  def add_castling_move(source, color)
    return if king_in_check?(color)

    @moves += @castling.castling_move(@moves, board, source, @meta_data.castling_rights, color)
    remove_moves_that_leads_to_check(source, color)
  end

  def to_s
    @board.keys.each_slice(8).with_object([]) { |row, string_rows| string_rows << create_row_string(row) }.join('/')
  end

  private

  def create_row_string(row)
    string = ''
    empty_cell_counter = 0
    row.each do |cell_marker|
      next empty_cell_counter += 1 if @board[cell_marker].empty?

      string += empty_cell_counter.to_s if empty_cell_counter.positive?
      empty_cell_counter = 0
      string += @board[cell_marker].piece_name
    end
    string += empty_cell_counter.to_s if empty_cell_counter.positive?
    string
  end
end
