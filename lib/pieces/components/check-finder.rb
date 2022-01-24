#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './move-generator'

# Check Finder
class CheckFinder
  def initialize(move_generator: MoveGenerator.new)
    @move_generator = move_generator
  end

  def cell_in_check?(king_position, board)
    @king_position = king_position
    @board = board
    check_possibilities.any? { |check_possibility| send(check_possibility) }
  end

  private

  def check_possibilities
    %i[horizontal_check? vertical_check? diagonal_check? knight_check? pawn_check? king_check?]
  end

  def horizontal_check?
    any_move_leads_to_check?(%w[r q R Q], @move_generator.horizontal_moves(@king_position, @board))
  end

  def vertical_check?
    any_move_leads_to_check?(%w[r q R Q], @move_generator.vertical_moves(@king_position, @board))
  end

  def diagonal_check?
    any_move_leads_to_check?(%w[b q B Q], @move_generator.diagonal_moves(@king_position, @board))
  end

  def knight_check?
    any_move_leads_to_check?(%w[n N], @move_generator.knight_moves(@king_position, @board))
  end

  def pawn_check?
    moves = black_pawn_moves if king_cell.piece_color == 'white'
    moves = white_pawn_moves if king_cell.piece_color == 'black'

    any_move_leads_to_check?(%w[p P], moves)
  end

  def black_pawn_moves
    [king_cell.top_right_diagonal, king_cell.top_left_diagonal].compact
  end

  def white_pawn_moves
    [king_cell.bottom_right_diagonal, king_cell.bottom_left_diagonal].compact
  end

  def king_check?
    any_move_leads_to_check?(%w[k K], @move_generator.king_moves(@king_position, @board))
  end

  def any_move_leads_to_check?(pieces_can_check, moves)
    occupied_moves(moves).any? { |move| leads_to_check?(pieces_can_check, move) }
  end

  def occupied_moves(moves)
    moves.select { |move| @board[move].occupied? }
  end

  def leads_to_check?(pieces_can_check, move)
    enemy?(move) && piece_in_move_can_check?(pieces_can_check, move)
  end

  def enemy?(move)
    @board[move].piece_color != king_cell.piece_color
  end

  def piece_in_move_can_check?(pieces_can_check, move)
    pieces_can_check.include?(@board[move].piece_name)
  end

  def king_cell
    @board[@king_position]
  end
end
