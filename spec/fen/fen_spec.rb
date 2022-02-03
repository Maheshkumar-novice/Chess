#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/fen/fen-processor'

describe FenProcessor do
  subject(:fen_processor) { described_class.new(piece_creator: piece_creator) }
  let(:piece_creator) { double('PieceCreator') }
  let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

  before do
    piece_creator = fen_processor.instance_variable_get(:@piece_creator)
    allow(piece_creator).to receive(:create_pieces).and_return(Array.new(64))
  end

  describe '#process' do
    before { fen_processor.process(fen) }

    it 'creates pieces' do
      pieces = fen_processor.instance_variable_get(:@pieces)
      expect(pieces).not_to be_nil
    end

    it 'creates 64 pieces' do
      pieces = fen_processor.instance_variable_get(:@pieces)
      expect(pieces.size).to eq(64)
    end

    it 'sets current color' do
      current_color = fen_processor.instance_variable_get(:@current_color)
      expect(current_color).not_to be_nil
    end

    it 'creates meta data' do
      meta_data = fen_processor.instance_variable_get(:@meta_data)
      expect(meta_data).not_to be_nil
    end

    it 'creates 4 meta data' do
      meta_data = fen_processor.instance_variable_get(:@meta_data)
      expect(meta_data.size).to eq(4)
    end
  end

  describe '#split' do
    it 'splits the given fen into 8 parts' do
      result = fen_processor.split(fen).size
      expect(result).to eq(8)
    end
  end

  describe '#to_pieces' do
    let(:split) { fen_processor.split(fen) }

    it 'converts rows into 64 pieces' do
      result = fen_processor.to_pieces(split).size
      expect(result).to eq(64)
    end
  end

  describe '#parse_color' do
    context 'when the value is w' do
      it 'returns white' do
        result = fen_processor.parse_color('w')
        expect(result).to eq('white')
      end
    end

    context 'when the value is b' do
      it 'returns black' do
        result = fen_processor.parse_color('b')
        expect(result).to eq('black')
      end
    end
  end

  describe '#parse_remaining_meta_data' do
    let(:meta_data) { fen_processor.split(fen)[-1].split[1..-1] }

    it 'returns a hash of 4 elements' do
      result = fen_processor.parse_remaining_meta_data(meta_data).size
      expect(result).to eq(4)
    end
  end
end
