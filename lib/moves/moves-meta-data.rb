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
      en_passant: @special_moves.en_passant?(source, destination, board, self),
      castling: @special_moves.castling?(source, destination, board, moves, @castling_rights)
    }
  end

  def update(source, destination, board)
    @castling_rights = @special_moves.update_castling_rights(source, destination, @castling_rights)
    @en_passant_move = @special_moves.create_en_passant_move(source, destination, board)
  end
end
