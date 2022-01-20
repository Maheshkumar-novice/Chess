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
  attr_reader :pieces, :current_color, :meta_data

  def initialize
    @pieces = nil
    @current_color = nil
    @meta_data = nil
  end

  def process(fen)
    rows = split(fen)
    meta_data_row = rows[-1].split[1..-1]
    @pieces = to_pieces(rows)
    @current_color = parse_color(meta_data_row[0])
    @meta_data = parse_remaining_meta_data(meta_data_row[1..-1])
  end

  private

  def split(fen)
    fen.split('/')
  end

  def to_pieces(rows)
    rows[-1] = rows[-1].split[0]
    create_pieces(rows)
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
    piece_symbol = value.downcase.to_sym
    piece = piece(piece_symbol)
    piece.name = value
    piece.color = piece_color(value)
    piece
  end

  def piece(piece_symbol)
    {
      r: Rook.new,
      b: Bishop.new,
      n: Knight.new,
      k: King.new,
      q: Queen.new,
      p: Pawn.new
    }[piece_symbol]
  end

  def piece_color(value)
    return 'white' if value.match?(/^[[:upper:]]{1}$/)

    'black'
  end

  def parse_color(value)
    return 'white' if value == 'w'

    'black'
  end

  def parse_remaining_meta_data(meta_data)
    {
      castling: meta_data[0],
      en_passant: meta_data[1],
      half_move_clock: meta_data[2],
      full_move_number: meta_data[3]
    }
  end
end
