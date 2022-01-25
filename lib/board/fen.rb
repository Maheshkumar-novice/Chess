#!/usr/bin/env ruby
# frozen_string_literal: true

# FEN Operations
class Fen
  attr_reader :pieces, :current_color, :meta_data

  def initialize(piece_creator: PieceCreator.new)
    @pieces = nil
    @current_color = nil
    @meta_data = nil
    @piece_creator = piece_creator
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
    @piece_creator.create_pieces(rows)
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
