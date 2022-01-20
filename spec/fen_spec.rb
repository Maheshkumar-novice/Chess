#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/fen'

describe Fen do
  subject(:fen) { described_class.new }

  describe '#process' do
    before do
      fen.process(fen_code)
    end

    context 'when default fen given' do
      let(:fen_code) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'creates 64 pieces' do
        result = fen.pieces.size
        expect(result).to eq(64)
      end

      it 'creates current_color' do
        result = fen.current_color
        expect(result).to eq('white')
      end

      it 'creates 4 meta_data' do
        result = fen.meta_data.size
        expect(result).to eq(4)
      end
    end

    context 'when custom fen given' do
      let(:fen_code) { 'rnb1kbnr/ppp2ppp/3ppq2/8/8/BPN5/P1PPPPPP/R2QKBNR b KQkq - 0 4' }

      it 'creates 64 pieces' do
        result = fen.pieces.size
        expect(result).to eq(64)
      end

      it 'creates current_color' do
        result = fen.current_color
        expect(result).to eq('black')
      end

      it 'creates 4 meta_data' do
        result = fen.meta_data.size
        expect(result).to eq(4)
      end
    end
  end
end
