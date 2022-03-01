#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/special-moves/en-passant/en-passant'
require_relative '../../../lib/fen/fen-processor'
require_relative '../../../lib/board/utils/board-creator'

describe EnPassant do
  subject(:en_passant) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
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
          result = en_passant.en_passant?(source, destination, board, meta_data)
          expect(result).to eq(true)
        end
      end

      context 'for non en_passant move' do
        it 'returns false' do
          source = :b4
          destination = :b3
          result = en_passant.en_passant?(source, destination, board, meta_data)
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
          result = en_passant.en_passant?(source, destination, board, meta_data)
          expect(result).to eq(false)
        end
      end

      context 'for non en_passant move' do
        it 'returns false' do
          source = :b4
          destination = :b3
          result = en_passant.en_passant?(source, destination, board, meta_data)
          expect(result).to eq(false)
        end
      end
    end
  end

  describe '#satisfy_en_passant_conditions?' do
    let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    context 'when piece is not a pawn' do
      it 'returns false' do
        source = :b8
        destination = :c6
        result = en_passant.satisfy_en_passant_conditions?(source, destination, board)
        expect(result).to eq(false)
      end
    end

    context 'when the move is not a double step' do
      it 'returns false' do
        source = :h2
        destination = :h3
        result = en_passant.satisfy_en_passant_conditions?(source, destination, board)
        expect(result).to eq(false)
      end
    end

    context 'when piece is a pawn and move is a double step' do
      it 'returns true' do
        source = :e2
        destination = :e4
        result = en_passant.satisfy_en_passant_conditions?(source, destination, board)
        expect(result).to eq(true)
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
        result = en_passant.en_passant_capture_cell(color, destination, board)
        expect(result).to eq(:b4)
      end
    end

    context 'for black color' do
      it 'returns correct cell' do
        color = 'black'
        destination = :c3
        result = en_passant.en_passant_capture_cell(color, destination, board)
        expect(result).to eq(:c4)
      end
    end
  end

  describe '#white_pawn_double_step?' do
    let(:fen_processor) { FenProcessor.new }
    let(:board_creator) { BoardCreator.new }
    before { fen_processor.process(fen) }

    context 'when the move is a double step' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/P7/8/1PPPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns true' do
        source = :a2
        destination = :a4
        result = en_passant.white_pawn_double_step?(source, destination, board)
        expect(result).to eq(true)
      end
    end

    context 'when the move is not a double step' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/P7/1P6/2PPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns false' do
        source = :b2
        destination = :b3
        result = en_passant.white_pawn_double_step?(source, destination, board)
        expect(result).to eq(false)
      end
    end
  end

  describe '#black_pawn_double_step?' do
    let(:fen_processor) { FenProcessor.new }
    let(:board_creator) { BoardCreator.new }
    before { fen_processor.process(fen) }

    context 'when the move is a double step' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2PPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns true' do
        source = :e7
        destination = :e5
        result = en_passant.black_pawn_double_step?(source, destination, board)
        expect(result).to eq(true)
      end
    end

    context 'when the move is not a double step' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2PPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns false' do
        source = :g7
        destination = :g6
        result = en_passant.black_pawn_double_step?(source, destination, board)
        expect(result).to eq(false)
      end
    end
  end

  describe '#en_passant_move_of_source' do
    let(:fen_processor) { FenProcessor.new }
    let(:board_creator) { BoardCreator.new }
    before { fen_processor.process(fen) }

    context 'for white piece' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns correct en_passant move cell marker' do
        source = :e2
        result = en_passant.en_passant_move_of_source(source, board)
        expected_result = :e3
        expect(result).to eq(expected_result)
      end
    end

    context 'for black piece' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns correct en_passant move cell marker' do
        source = :b7
        result = en_passant.en_passant_move_of_source(source, board)
        expected_result = :b6
        expect(result).to eq(expected_result)
      end
    end
  end
end
