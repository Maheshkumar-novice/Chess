#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/fen'

describe Fen do
  subject(:fen) { described_class.new }

  describe '#to_pieces' do
    context 'when default fen given' do
      fen_code = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

      it 'returns an array of board pieces with 32 nils in correct places' do
        pieces_array = [nil] * 32
        result = fen.to_pieces(fen_code)
        expect(result[16..47]).to eq(pieces_array)
      end

      it 'returns an array with first element as black rook' do
        result = fen.to_pieces(fen_code)[0]
        expect(result.name).to eq('r')
        expect(result.color).to eq('black')
      end

      it 'returns an array with last element as white rook' do
        result = fen.to_pieces(fen_code)[-1]
        expect(result.name).to eq('R')
        expect(result.color).to eq('white')
      end
    end

    context 'when custom fen given' do
      fen_code = 'rnb1kbnr/ppp2ppp/3ppq2/8/8/BPN5/P1PPPPPP/R2QKBNR w KQkq - 0 4'

      it 'returns an array with 42th element as white pawn' do
        result = fen.to_pieces(fen_code)[41]
        expect(result.name).to eq('P')
        expect(result.color).to eq('white')
      end

      it 'returns an array with first element as black rook' do
        result = fen.to_pieces(fen_code)[0]
        expect(result.name).to eq('r')
        expect(result.color).to eq('black')
      end

      it 'returns an array with last element as white rook' do
        result = fen.to_pieces(fen_code)[-1]
        expect(result.name).to eq('R')
        expect(result.color).to eq('white')
      end
    end
  end
end
