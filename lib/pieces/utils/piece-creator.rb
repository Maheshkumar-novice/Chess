#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../rook'
require_relative '../knight'
require_relative '../bishop'
require_relative '../king'
require_relative '../queen'
require_relative '../pawn'

# Creates pieces from array of strings from fen
class PieceCreator
  def create_pieces(rows)
    rows.each_with_object([]) { |row, pieces| row.each_char { |value| pieces.concat(create_piece(value)) } }
  end

  def create_piece(value)
    return create_nil_pieces(value.to_i) if value.match?(/^[1-8]{1}$/)

    [create_valid_piece(value)]
  end

  def create_nil_pieces(value)
    [nil] * value
  end

  def create_valid_piece(value)
    piece = piece(value.downcase)
    piece.name = value
    piece.color = piece_color(value)
    piece
  end

  def piece(piece_name)
    case piece_name
    when 'r' then Rook.new
    when 'b' then Bishop.new
    when 'n' then Knight.new
    when 'k' then King.new
    when 'q' then Queen.new
    when 'p' then Pawn.new
    end
  end

  def piece_color(value)
    value.match?(/^[[:upper:]]{1}$/) ? 'white' : 'black'
  end
end
