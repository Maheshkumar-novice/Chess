#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './pieces/rook'
require_relative './pieces/knight'
require_relative './pieces/bishop'
require_relative './pieces/king'
require_relative './pieces/queen'
require_relative './pieces/pawn'

# FEN Operations
class Fen
  def to_pieces(fen)
    create_pieces(split(fen))
  end

  private

  def split(fen)
    rows = fen.split('/')
    rows[-1] = rows[-1].split[0]
    rows
  end

  def create_pieces(rows)
    pieces = []
    rows.each do |row|
      row.chars.each do |value|
        pieces += make_piece(value)
      end
    end
    pieces
  end

  def make_piece(value)
    pieces = []
    if value.match?(/^[1-8]{1}$/)
      pieces += create_nil_pieces(value)
    else
      pieces << create_valid_piece(value)
    end
    pieces
  end

  def create_nil_pieces(value)
    [nil] * value.to_i
  end

  def create_valid_piece(value)
    piece = piece(value)
    piece.name = value
    piece.color = piece_color(value)
    piece
  end

  def piece(value)
    {
      r: Rook.new,
      b: Bishop.new,
      n: Knight.new,
      k: King.new,
      q: Queen.new,
      p: Pawn.new
    }[value.downcase.to_sym]
  end

  def piece_color(value)
    return 'white' if value.match?(/^[[:upper:]]{1}$/)

    'black'
  end
end
