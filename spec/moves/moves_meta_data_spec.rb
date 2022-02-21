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

  describe '#white_double_step?' do
    let(:fen_processor) { FenProcessor.new }
    let(:board_creator) { BoardCreator.new }
    before { fen_processor.process(fen) }

    context 'when the move is a double step' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/P7/8/1PPPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }
      before do
        moves_meta_data.instance_variable_set(:@board, board)
        moves_meta_data.instance_variable_set(:@source, :a2)
        moves_meta_data.instance_variable_set(:@destination, :a4)
      end

      it 'returns true' do
        result = moves_meta_data.white_double_step?
        expect(result).to eq(true)
      end
    end

    context 'when the move is not a double step' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/P7/1P6/2PPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }
      before do
        moves_meta_data.instance_variable_set(:@board, board)
        moves_meta_data.instance_variable_set(:@source, :b2)
        moves_meta_data.instance_variable_set(:@destination, :b3)
      end

      it 'returns false' do
        result = moves_meta_data.white_double_step?
        expect(result).to eq(false)
      end
    end
  end

  describe '#black_double_step?' do
    let(:fen_processor) { FenProcessor.new }
    let(:board_creator) { BoardCreator.new }
    before { fen_processor.process(fen) }

    context 'when the move is a double step' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2PPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }
      before do
        moves_meta_data.instance_variable_set(:@board, board)
        moves_meta_data.instance_variable_set(:@source, :e7)
        moves_meta_data.instance_variable_set(:@destination, :e5)
      end

      it 'returns true' do
        result = moves_meta_data.black_double_step?
        expect(result).to eq(true)
      end
    end

    context 'when the move is not a double step' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2PPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }
      before do
        moves_meta_data.instance_variable_set(:@board, board)
        moves_meta_data.instance_variable_set(:@source, :g7)
        moves_meta_data.instance_variable_set(:@destination, :g6)
      end

      it 'returns false' do
        result = moves_meta_data.black_double_step?
        expect(result).to eq(false)
      end
    end
  end

  describe '#create_en_passant_move' do
    let(:fen_processor) { FenProcessor.new }
    let(:board_creator) { BoardCreator.new }
    before { fen_processor.process(fen) }

    context 'for white piece' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }
      before do
        moves_meta_data.instance_variable_set(:@board, board)
        moves_meta_data.instance_variable_set(:@source, :e2)
      end

      it 'returns correct en_passant move cell marker' do
        result = moves_meta_data.create_en_passant_move
        expected_result = :e3
        expect(result).to eq(expected_result)
      end
    end

    context 'for black piece' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }
      before do
        moves_meta_data.instance_variable_set(:@board, board)
        moves_meta_data.instance_variable_set(:@source, :b7)
      end

      it 'returns correct en_passant move cell marker' do
        result = moves_meta_data.create_en_passant_move
        expected_result = :b6
        expect(result).to eq(expected_result)
      end
    end
  end
end
