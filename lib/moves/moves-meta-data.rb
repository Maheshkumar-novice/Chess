#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../special-moves/castling/castling'
require_relative '../special-moves/en-passant/en-passant'

# Meta Data about Moves
class MovesMetaData
  attr_reader :pieces_changed, :en_passant_move, :castling_rights

  def initialize
    @pieces_changed = {}
    @castling_rights = '-'
    @en_passant_move = :-
    @castling = Castling.new
    @en_passant = EnPassant.new
  end

  def update_en_passant_move_to(value)
    @en_passant_move = value.to_sym
  end

  def update_castling_rights_to(value)
    @castling_rights = value
  end

  def update_changed_pieces_state(pieces_changed)
    @pieces_changed = pieces_changed
  end

  def special_moves_state(board, source, destination, moves)
    {
      castling: @castling.castling?(source, destination, board, moves, @castling_rights),
      en_passant: @en_passant.en_passant?(source, destination, board, self)
    }
  end

  def update(source, destination, board)
    @castling_rights = @castling.update_castling_rights(source, destination, @castling_rights)
    @en_passant_move = @en_passant.create_en_passant_move(source, destination, board)
  end

  def to_s
    castling_rights = @castling_rights.empty? ? '-' : @castling_rights
    "#{castling_rights} #{@en_passant_move}"
  end
end
