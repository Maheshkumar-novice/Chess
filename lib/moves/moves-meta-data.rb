#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './special-moves'

# Meta Data about Moves
class MovesMetaData
  attr_reader :pieces_changed, :en_passant_move, :castling_rights

  def initialize
    @pieces_changed = {}
    @castling_rights = '-'
    @en_passant_move = :-
    @special_moves = SpecialMoves.new
  end

  def update_en_passant_move_to(value)
    @en_passant = value.to_sym
  end

  def update_castling_rights_to(value)
    @castling_rights = value
  end

  def update_changed_pieces_state(pieces_changed)
    @pieces_changed = pieces_changed
  end

  def special_moves_state(board, source, destination, moves)
    {
      en_passant: en_passant?(board, source, destination),
      castling: castling?(board, source, destination, moves)
    }
  end

  def en_passant?(board, source, destination)
    @en_passant_move != :- && board[source].pawn? && @en_passant_move == destination
  end

  def castling?(board, source, destination, moves)
    board[source].king? && @special_moves.castling_move(moves, board, source, @castling_rights,
                                                        board[source].piece_color).include?(destination)
  end

  def update(source, destination, board)
    @castling_rights = @special_moves.update_castling_rights(source, destination, @castling_rights)
    @en_passant_move = @special_moves.create_en_passant_move(source, destination, board)
  end
end
