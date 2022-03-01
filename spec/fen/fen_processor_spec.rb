#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/fen/fen-processor'

describe FenProcessor do
  subject(:fen_processor) { described_class.new }
  let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

  before do
    piece_creator = fen_processor.instance_variable_get(:@piece_creator)
    allow(piece_creator).to receive(:create_pieces).and_return(Array.new(64))
  end

  describe '#process' do
    before { fen_processor.process(fen) }

    it 'creates 64 pieces' do
      pieces = fen_processor.instance_variable_get(:@pieces)
      expect(pieces.size).to eq(64)
    end

    it 'sets current color' do
      current_color = fen_processor.instance_variable_get(:@current_color)
      expect(current_color).to eq('white')
    end
  end

  describe '#parse_remaining_meta_data' do
    let(:meta_data) { %w[a b c d] }

    it 'sends :update_castling_rights_to message to meta_data' do
      meta_data_obj = fen_processor.instance_variable_get(:@meta_data)
      expect(meta_data_obj).to receive(:update_castling_rights_to).with(meta_data[0])
      fen_processor.parse_remaining_meta_data(meta_data)
    end

    it 'sends :update_en_passant_move_to message to meta_data' do
      meta_data_obj = fen_processor.instance_variable_get(:@meta_data)
      expect(meta_data_obj).to receive(:update_en_passant_move_to).with(meta_data[1])
      fen_processor.parse_remaining_meta_data(meta_data)
    end

    it 'sends :update_half_move_clock message to counters' do
      counters_obj = fen_processor.instance_variable_get(:@counters)
      expect(counters_obj).to receive(:update_half_move_clock).with(meta_data[2])
      fen_processor.parse_remaining_meta_data(meta_data)
    end

    it 'sends :update_full_move_number message to counters' do
      counters_obj = fen_processor.instance_variable_get(:@counters)
      expect(counters_obj).to receive(:update_full_move_number).with(meta_data[3])
      fen_processor.parse_remaining_meta_data(meta_data)
    end
  end
end
