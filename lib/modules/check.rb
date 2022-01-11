#!/usr/bin/env ruby
# frozen_string_literal: true

# Check Module
module Check
  private

  def king_in_check?(color)
    king_position = king_position(color)
    check_possibilities.any? do |check_possibility|
      send(check_possibility, king_position)
    end
  end

  def move_leads_to_check?(source, destination, color)
    @board.make_move(source, destination)
    king_in_check = king_in_check?(color)
    @board.make_move(destination, source)

    king_in_check
  end

  def check_possibilities
    %i[horizontal_check? vertical_check? diagonal_check? knight_check? pawn_check? king_check?]
  end

  def eliminate_nil_pieces(moves)
    moves.reject do |move|
      @board[move].piece.nil?
    end
  end

  def different_colors?(move, king_position)
    @board[move].piece.color != @board[king_position].piece.color
  end

  def moves_piece_in_pieces_can_check?(pieces_can_check, move)
    pieces_can_check.include?(@board[move].piece.name.downcase)
  end

  def check?(pieces_can_check, move, king_position)
    different_colors?(move, king_position) && moves_piece_in_pieces_can_check?(pieces_can_check, move)
  end

  def horizontal_check?(king_position)
    horizontal_moves = eliminate_nil_pieces(horizontal_moves(king_position))
    horizontal_moves.any? do |horizontal_move|
      check?(%w[r q], horizontal_move, king_position)
    end
  end

  def vertical_check?(king_position)
    vertical_moves = eliminate_nil_pieces(vertical_moves(king_position))
    vertical_moves.any? do |vertical_move|
      check?(%w[r q], vertical_move, king_position)
    end
  end

  def diagonal_check?(king_position)
    diagonal_moves = eliminate_nil_pieces(diagonal_moves(king_position))
    diagonal_moves.any? do |diagonal_move|
      check?(%w[b q], diagonal_move, king_position)
    end
  end

  def knight_check?(king_position)
    knight_moves = eliminate_nil_pieces(knight_moves(king_position))
    knight_moves.any? do |knight_move|
      check?(%w[n], knight_move, king_position)
    end
  end

  def pawn_check?(king_position)
    color = @board[king_position].piece.color
    return black_pawn_check?(king_position) if color == 'white'
    return white_pawn_check?(king_position) if color == 'black'
  end

  def black_pawn_check?(king_position)
    moves = []
    moves << @board[king_position].top_right_diagonal
    moves << @board[king_position].top_left_diagonal
    moves = eliminate_nil_pieces(moves)
    moves.any? do |move|
      check?(%w[p], move, king_position)
    end
  end

  def white_pawn_check?(king_position)
    moves = []
    moves << @board[king_position].bottom_right_diagonal
    moves << @board[king_position].bottom_left_diagonal
    moves = eliminate_nil_pieces(moves)
    moves.any? do |move|
      check?(%w[p], move, king_position)
    end
  end

  def king_check?(king_position)
    king_moves = eliminate_nil_pieces(king_moves(king_position))
    king_moves.any? do |king_move|
      check?(%w[k], king_move, king_position)
    end
  end
end
