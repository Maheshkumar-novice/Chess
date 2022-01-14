#!/usr/bin/env ruby
# frozen_string_literal: true

# Check Module
module Check
  private

  def check_possibilities
    %i[horizontal_check? vertical_check? diagonal_check? knight_check? pawn_check? king_check?]
  end

  def horizontal_check?(king_position, board)
    horizontal_moves = generate_all_moves_from_directions(%i[row_right row_left], king_position, board)
    horizontal_moves = eliminate_nil_pieces(horizontal_moves, board)
    horizontal_moves.any? do |horizontal_move|
      check?(%w[r q], horizontal_move, king_position, board)
    end
  end

  def vertical_check?(king_position, board)
    vertical_moves = generate_all_moves_from_directions(%i[column_above column_below], king_position, board)
    vertical_moves = eliminate_nil_pieces(vertical_moves, board)
    vertical_moves.any? do |vertical_move|
      check?(%w[r q], vertical_move, king_position, board)
    end
  end

  def diagonal_check?(king_position, board)
    diagonal_moves = generate_all_moves_from_directions(%i[top_left_diagonal
                                                           top_right_diagonal
                                                           bottom_right_diagonal
                                                           bottom_left_diagonal], king_position, board)
    diagonal_moves = eliminate_nil_pieces(diagonal_moves, board)
    diagonal_moves.any? do |diagonal_move|
      check?(%w[b q], diagonal_move, king_position, board)
    end
  end

  def knight_check?(king_position, board)
    knight_moves = knight_moves(king_position, board)
    knight_moves = eliminate_nil_pieces(knight_moves, board)
    knight_moves.any? do |knight_move|
      check?(%w[n], knight_move, king_position, board)
    end
  end

  def pawn_check?(king_position, board)
    color = board[king_position].piece.color
    return black_pawn_check?(king_position, board) if color == 'white'
    return white_pawn_check?(king_position, board) if color == 'black'
  end

  def black_pawn_check?(king_position, board)
    moves = []
    moves << board[king_position].top_right_diagonal
    moves << board[king_position].top_left_diagonal
    moves = eliminate_nil_pieces(moves, board)
    moves.any? do |move|
      check?(%w[p], move, king_position, board)
    end
  end

  def white_pawn_check?(king_position, board)
    moves = []
    moves << board[king_position].bottom_right_diagonal
    moves << board[king_position].bottom_left_diagonal
    moves = eliminate_nil_pieces(moves, board)
    moves.any? do |move|
      check?(%w[p], move, king_position, board)
    end
  end

  def king_check?(king_position, board)
    king_moves = eliminate_nil_pieces(moves(board), board)
    king_moves.any? do |king_move|
      check?(%w[k], king_move, king_position, board)
    end
  end

  def check?(pieces_can_check, move, king_position, board)
    different_colors?(move, king_position, board) && moves_piece_in_pieces_can_check?(pieces_can_check, move, board)
  end

  def different_colors?(move, king_position, board)
    board[move].piece.color != board[king_position].piece.color
  end

  def moves_piece_in_pieces_can_check?(pieces_can_check, move, board)
    pieces_can_check.include?(board[move].piece.name.downcase)
  end

  def eliminate_nil_pieces(moves, board)
    moves.compact.reject do |move|
      board[move].piece.nil?
    end
  end
end
