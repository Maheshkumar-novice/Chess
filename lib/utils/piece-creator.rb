#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../pieces/rook'
require_relative '../pieces/knight'
require_relative '../pieces/bishop'
require_relative '../pieces/king'
require_relative '../pieces/queen'
require_relative '../pieces/pawn'

# Piece Creator
class PieceCreator
  def create_pieces(rows)
    pieces = []
    rows.each do |row|
      row.chars.each do |value|
        pieces.concat(make_piece(value))
      end
    end
    pieces
  end

  def make_piece(value)
    pieces = []
    if value.match?(/^[1-8]{1}$/)
      pieces += create_nil_pieces(value.to_i)
    else
      pieces << create_valid_piece(value)
    end
    pieces
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
    return 'white' if value.match?(/^[[:upper:]]{1}$/)

    'black'
  end
end
