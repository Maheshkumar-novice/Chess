#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './move-generator'

# Check Finder
class CheckFinder
  def initialize(move_generator: MoveGenerator.new)
    @move_generator = move_generator
  end

  def cell_in_check?(cell, board)
    check_possibilities.any? do |check_possibility|
      send(check_possibility, cell, board)
    end
  end

  private

  def check_possibilities
    %i[horizontal_check? vertical_check? diagonal_check? knight_check? pawn_check? king_check?]
  end

  def horizontal_check?(king_position, board)
    horizontal_moves = @move_generator.generate_all_moves_from_directions(%i[row_right row_left], king_position, board)
    any_move_leads_to_check?(%w[r q], horizontal_moves, king_position, board)
  end

  def vertical_check?(king_position, board)
    vertical_moves = @move_generator.generate_all_moves_from_directions(%i[column_above column_below], king_position,
                                                                        board)
    any_move_leads_to_check?(%w[r q], vertical_moves, king_position, board)
  end

  def diagonal_check?(king_position, board)
    diagonal_moves = @move_generator.generate_all_moves_from_directions(%i[top_left_diagonal
                                                                           top_right_diagonal
                                                                           bottom_right_diagonal
                                                                           bottom_left_diagonal], king_position, board)
    any_move_leads_to_check?(%w[b q], diagonal_moves, king_position, board)
  end

  def knight_check?(king_position, board)
    knight_moves = @move_generator.knight_moves(king_position, board)
    any_move_leads_to_check?(%w[n], knight_moves, king_position, board)
  end

  def pawn_check?(king_position, board)
    color = board[king_position].piece_color
    return black_pawn_check?(king_position, board) if color == 'white'
    return white_pawn_check?(king_position, board) if color == 'black'
  end

  def black_pawn_check?(king_position, board)
    moves = []
    moves << board[king_position].top_right_diagonal
    moves << board[king_position].top_left_diagonal
    moves = moves.compact
    any_move_leads_to_check?(%w[p], moves, king_position, board)
  end

  def white_pawn_check?(king_position, board)
    moves = []
    moves << board[king_position].bottom_right_diagonal
    moves << board[king_position].bottom_left_diagonal
    moves = moves.compact
    any_move_leads_to_check?(%w[p], moves, king_position, board)
  end

  def king_check?(king_position, board)
    king_moves = @move_generator.generate_single_step_moves_from_directions(%i[row_right
                                                                               row_left
                                                                               column_above
                                                                               column_below
                                                                               top_left_diagonal
                                                                               top_right_diagonal
                                                                               bottom_right_diagonal
                                                                               bottom_left_diagonal], king_position, board)
    any_move_leads_to_check?(%w[k], king_moves, king_position, board)
  end

  def any_move_leads_to_check?(pieces_can_check, direction_moves, king_position, board)
    direction_moves = reject_nil_pieces(direction_moves, board)
    direction_moves.any? do |direction_move|
      check?(pieces_can_check, direction_move, king_position, board)
    end
  end

  def reject_nil_pieces(moves, board)
    moves.select do |move|
      board[move].occupied?
    end
  end

  def check?(pieces_can_check, move, king_position, board)
    different_colors?(move, king_position, board) && move_piece_in_pieces_can_check?(pieces_can_check, move, board)
  end

  def different_colors?(move, king_position, board)
    board[move].piece_color != board[king_position].piece_color
  end

  def move_piece_in_pieces_can_check?(pieces_can_check, move, board)
    pieces_can_check.include?(board[move].piece_name.downcase)
  end
end
