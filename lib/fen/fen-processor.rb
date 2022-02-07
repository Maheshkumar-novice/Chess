#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../pieces/utils/piece-creator'
require_relative '../moves/moves-meta-data'

# Operates on FEN code
class FenProcessor
  attr_reader :pieces, :current_color, :meta_data

  def initialize(piece_creator: PieceCreator.new, meta_data: MovesMetaData.new)
    @pieces = nil
    @current_color = nil
    @piece_creator = piece_creator
    @meta_data = meta_data
  end

  def process(fen)
    rows = split(fen)
    meta_data_row = rows[-1].split[1..-1]
    @pieces = to_pieces(rows)
    @current_color = parse_color(meta_data_row[0])
    parse_remaining_meta_data(meta_data_row[1..-1])
  end

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
    @meta_data.en_passant = meta_data[1]
  end
end
