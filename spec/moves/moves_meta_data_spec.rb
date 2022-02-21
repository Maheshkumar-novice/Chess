#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/moves/moves-meta-data'
require_relative '../../lib/fen/fen-processor'
require_relative '../../lib/board/utils/board-creator'

describe MovesMetaData do
  subject(:moves_meta_data) { described_class.new }

  describe '#special_moves_state' do
    let(:fen_processor) { FenProcessor.new }
    let(:board_creator) { BoardCreator.new }
    before { fen_processor.process(fen) }

    context 'en_passant' do
      context 'when source piece is not a pawn' do
        let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
        let(:board) { board_creator.create_board(fen_processor.pieces) }
        before { moves_meta_data.instance_variable_set(:@en_passant_move, :a3) }

        it 'returns a hash with en_passant as false' do
          source = :b4
          result = moves_meta_data.special_moves_state(board, source)
          expected_result = { en_passant: false }
          expect(result).to eq(expected_result)
        end
      end

      context 'when en_passant available' do
        let(:fen) { 'rnbqkbnr/p1pp1p1p/6p1/4p3/Pp6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
        let(:board) { board_creator.create_board(fen_processor.pieces) }
        before { moves_meta_data.instance_variable_set(:@en_passant_move, :a3) }

        it 'returns a hash with en_passant as true' do
          source = :b4
          result = moves_meta_data.special_moves_state(board, source)
          expected_result = { en_passant: true }
          expect(result).to eq(expected_result)
        end
      end

      context 'when en_passant not available' do
        let(:fen) { 'rnbqkbnr/p1pp1p1p/6p1/4p3/Pp6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
        let(:board) { board_creator.create_board(fen_processor.pieces) }
        before { moves_meta_data.instance_variable_set(:@en_passant_move, :-) }

        it 'returns a hash with en_passant as false' do
          source = :b4
          result = moves_meta_data.special_moves_state(board, source)
          expected_result = { en_passant: false }
          expect(result).to eq(expected_result)
        end
      end
    end
  end
end
