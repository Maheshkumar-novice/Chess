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

  describe '#create_nil_pieces' do
    it 'creates 4 nil pieces' do
      result = piece_creator.create_nil_pieces(4)
      expected_result = result.all?(&:nil?)
      expect(expected_result).to eq(true)
      expect(result.size).to eq(4)
    end

    it 'creates 0 nil pieces' do
      result = piece_creator.create_nil_pieces(0)
      expected_result = result.all?(&:nil?)
      expect(expected_result).to eq(true)
      expect(result.size).to eq(0)
    end
  end

  describe '#create_valid_piece' do
    it 'creates a valid black color piece object' do
      result = piece_creator.create_valid_piece('p')
      expect(result).to be_a(Piece)
      expect(result.name).to eq('p')
      expect(result.color).to eq('black')
    end

    it 'creates a valid white color piece object' do
      result = piece_creator.create_valid_piece('P')
      expect(result).to be_a(Piece)
      expect(result.name).to eq('P')
      expect(result.color).to eq('white')
    end
  end

  describe '#piece' do
    it 'returns rook object for input r' do
      result = piece_creator.piece('r')
      expect(result).to be_a(Rook)
    end

    it 'returns bishop object for input b' do
      result = piece_creator.piece('b')
      expect(result).to be_a(Bishop)
    end

    it 'returns knight object for input n' do
      result = piece_creator.piece('n')
      expect(result).to be_a(Knight)
    end

    it 'returns king object for input k' do
      result = piece_creator.piece('k')
      expect(result).to be_a(King)
    end

    it 'returns queen object for input q' do
      result = piece_creator.piece('q')
      expect(result).to be_a(Queen)
    end

    it 'returns pawn object for input p' do
      result = piece_creator.piece('p')
      expect(result).to be_a(Pawn)
    end
  end

  describe '#piece_color' do
    it 'returns white when input is single upper case' do
      result = piece_creator.piece_color('P')
      expect(result).to eq('white')
    end

    it 'returns black when input is single lower case' do
      result = piece_creator.piece_color('p')
      expect(result).to eq('black')
    end
  end
end
