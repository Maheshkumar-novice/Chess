#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../pieces/utils/piece-creator'
require_relative '../moves/moves-meta-data'

# Operates on FEN code
class FenProcessor
  attr_reader :pieces, :current_color, :meta_data

  def initialize
    @pieces = nil
    @current_color = nil
    @piece_creator = PieceCreator.new
    @meta_data = MovesMetaData.new
  end

  def process(fen)
    rows = fen.split('/')
    rows[-1], meta_data_row = parse_last_row(rows[-1])
    @pieces = @piece_creator.create_pieces(rows)
    @current_color = parse_color(meta_data_row[0])
    parse_remaining_meta_data(meta_data_row[1..])
  end

  def parse_last_row(row)
    split = row.split
    [split[0], split[1..]]
  end

  def parse_color(value)
    value == 'w' ? 'white' : 'black'
  end

  def parse_remaining_meta_data(meta_data)
    @meta_data.update_castling_rights_to(meta_data[0])
    @meta_data.update_en_passant_move_to(meta_data[1])
  end
end
