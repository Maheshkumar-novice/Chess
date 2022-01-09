#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './piece'

# FEN Operations
class Fen
  def to_pieces(fen)
    create_pieces(split(fen))
  end

  private

  def split(fen)
    splitted = fen.split('/')
    splitted[-1] = splitted[-1].split[0]
    splitted.map!(&:reverse).reverse
  end

  def create_pieces(splitted)
    pieces = []
    splitted.each do |row|
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
    piece = Piece.new
    piece.name = value
    piece.color = piece_color(value)
    piece
  end

  def piece_color(value)
    return 'black' if value.match?(/^[[:upper:]]{1}$/)

    'white'
  end
end
