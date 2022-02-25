#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './special-moves'

# Meta Data about Moves
class MovesMetaData
  attr_accessor :en_passant_move, :castling_rights
  attr_reader :pieces_changed

  def initialize
    @pieces_changed = {}
    @castling_rights = '-'
    @en_passant_move = :-
    @special_moves = SpecialMoves.new
  end

  def update_changed_pieces_state(pieces_changed)
    @pieces_changed = pieces_changed
  end

  def special_moves_state(board, source, destination, moves)
    {
      en_passant: (@en_passant_move != :- && board[source].pawn? && @en_passant_move == destination),
      castling: board[source].king? && !@special_moves.castling_move(moves, board, source, @castling_rights,
                                                                     board[source].piece_color).empty?
    }
  end

  def update(source, destination, board)
    update_castling_rights(source, destination)
    update_en_passant(source, destination, board)
  end

  def update_castling_rights(source, destination)
    @castling_rights = @special_moves.update_castling_rights(source, destination, @castling_rights)
  end

  def update_en_passant(source, destination, board)
    @en_passant_move = @special_moves.create_en_passant_move(source, destination, board)
  end
end
