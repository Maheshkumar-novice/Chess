#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/moves/special-moves'
require_relative '../../lib/fen/fen-processor'
require_relative '../../lib/board/utils/board-creator'

describe SpecialMoves do
  subject(:special_moves) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  before { fen_processor.process(fen) }

  describe '#en_passant?' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }

    context 'with board with en_passant' do
      let(:fen) { 'rnbqkbnr/p1pppppp/8/P7/1pP5/8/1P1PPPPP/RNBQKBNR w KQkq c3 0 1' }

      context 'for en_passant move' do
        it 'returns true' do
          source = :b4
          destination = :c3
          result = special_moves.en_passant?(source, destination, board, meta_data)
          expect(result).to eq(true)
        end
      end

      context 'for non en_passant move' do
        it 'returns false' do
          source = :b4
          destination = :b3
          result = special_moves.en_passant?(source, destination, board, meta_data)
          expect(result).to eq(false)
        end
      end
    end

    context 'with board without en_passant' do
      let(:fen) { 'rnbqkbnr/p1pppppp/8/P7/1pP5/8/1P1PPPPP/RNBQKBNR w KQkq - 0 1' }

      context 'for en_passant move' do
        it 'returns false' do
          source = :b4
          destination = :c3
          result = special_moves.en_passant?(source, destination, board, meta_data)
          expect(result).to eq(false)
        end
      end

      context 'for non en_passant move' do
        it 'returns false' do
          source = :b4
          destination = :b3
          result = special_moves.en_passant?(source, destination, board, meta_data)
          expect(result).to eq(false)
        end
      end
    end
  end

  describe '#en_passant_capture_cell' do
    let(:fen) { 'rnbqkbnr/p1pppppp/8/P7/1pP5/8/1P1PPPPP/RNBQKBNR w KQkq c3 0 1' }
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    context 'for white color' do
      it 'returns correct cell' do
        color = 'white'
        destination = :b5
        result = special_moves.en_passant_capture_cell(color, destination, board)
        expect(result).to eq(:b4)
      end
    end

    context 'for black color' do
      it 'returns correct cell' do
        color = 'black'
        destination = :c3
        result = special_moves.en_passant_capture_cell(color, destination, board)
        expect(result).to eq(:c4)
      end
    end
  end
end
