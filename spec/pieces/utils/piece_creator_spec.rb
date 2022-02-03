#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/pieces/utils/piece-creator'
require_relative '../../../lib/fen/fen-processor'

describe PieceCreator do
  subject(:piece_creator) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

  describe '#create_pieces' do
    it 'creates 64 pieces' do
      rows = fen_processor.split(fen)
      rows[-1] = rows[-1].split[0]
      result = piece_creator.create_pieces(rows).size
      expect(result).to eq(64)
    end
  end

  describe '#make_piece' do
    context 'when value is a number' do
      let(:number) { '8' }

      it 'returns an array of size number' do
        result = piece_creator.make_piece(number).size
        expect(result).to eq(number.to_i)
      end

      it 'returns an array full of nils' do
        result = piece_creator.make_piece(number)
        expect(result).to all(be_nil)
      end
    end

    context 'when value is a character' do
      let(:character) { 'r' }

      it 'returns an array' do
        result = piece_creator.make_piece(character)
        expect(result).to be_an(Array)
      end

      it 'returns a piece' do
        result = piece_creator.make_piece(character)[0]
        expect(result).to be_a(Piece)
      end
    end
  end
end
