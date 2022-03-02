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

    context 'castling' do
      let(:moves) { [] }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      context 'when castling move not available' do
        let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
        before do
          moves_meta_data.instance_variable_set(:@castling_rights, 'KQkq')
          allow(moves_meta_data.instance_variable_get(:@castling)).to receive(:castling?).and_return(false)
        end

        it 'returns a hash with castling as false' do
          source = :e1
          destination = :c1
          result = moves_meta_data.special_moves_state(board, source, destination, moves)
          expected_result = false
          expect(result[:castling]).to eq(expected_result)
        end
      end

      context 'when castling available' do
        let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
        before do
          moves_meta_data.instance_variable_set(:@castling_rights, 'KQkq')
          allow(moves_meta_data.instance_variable_get(:@castling)).to receive(:castling?).and_return(true)
        end

        it 'returns a hash with castling as true' do
          source = :e1
          destination = :c1
          result = moves_meta_data.special_moves_state(board, source, destination, moves)
          expected_result = true
          expect(result[:castling]).to eq(expected_result)
        end
      end
    end

    context 'en_passant' do
      let(:moves) { [] }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      context 'when en_passant available' do
        let(:fen) { 'rnbqkbnr/p1pp1p1p/6p1/4p3/Pp6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
        before do
          moves_meta_data.instance_variable_set(:@en_passant_move, :a3)
          allow(moves_meta_data.instance_variable_get(:@en_passant)).to receive(:en_passant?).and_return(true)
        end

        it 'returns a hash with en_passant as true' do
          source = :b4
          destination = :a3
          result = moves_meta_data.special_moves_state(board, source, destination, moves)
          expected_result = true
          expect(result[:en_passant]).to eq(expected_result)
        end
      end

      context 'when en_passant not available' do
        let(:fen) { 'rnbqkbnr/p1pp1p1p/6p1/4p3/Pp6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
        before do
          moves_meta_data.instance_variable_set(:@en_passant_move, :-)
          allow(moves_meta_data.instance_variable_get(:@en_passant)).to receive(:en_passant?).and_return(false)
        end

        it 'returns a hash with en_passant as false' do
          source = :b4
          destination = :a3
          result = moves_meta_data.special_moves_state(board, source, destination, moves)
          expected_result = false
          expect(result[:en_passant]).to eq(expected_result)
        end
      end
    end
  end

  describe '#update' do
    before do
      allow(moves_meta_data.instance_variable_get(:@castling)).to receive(:update_castling_rights).and_return('castling')
      allow(moves_meta_data.instance_variable_get(:@en_passant)).to receive(:create_en_passant_move).and_return('en_passant')
    end

    it 'updates castling_rights' do
      source = :a1
      destination = :a2
      board = {}
      moves_meta_data.update(source, destination, board)
      castling_rights = moves_meta_data.instance_variable_get(:@castling_rights)
      expect(castling_rights).to eq('castling')
    end

    it 'update en_passant_move' do
      source = :a1
      destination = :a2
      board = {}
      moves_meta_data.update(source, destination, board)
      en_passant_move = moves_meta_data.instance_variable_get(:@en_passant_move)
      expect(en_passant_move).to eq('en_passant')
    end
  end

  describe '#to_s' do
    before do
      moves_meta_data.instance_variable_set(:@castling_rights, 'KQk')
      moves_meta_data.instance_variable_set(:@en_passant_move, :e6)
    end

    it 'returns the string of castling_rights and en_passant_move joined' do
      result = moves_meta_data.to_s
      expected_result = 'KQk e6'
      expect(result).to eq(expected_result)
    end
  end
end
