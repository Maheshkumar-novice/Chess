#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/moves/special-moves'
require_relative '../../lib/fen/fen-processor'
require_relative '../../lib/board/utils/board-creator'

describe SpecialMoves do
  subject(:special_moves) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
  before { fen_processor.process(fen) }

  describe '#update_castling_rights' do
    let(:castling_rights) { 'KQkq' }

    context 'for white' do
      context 'when queen side rook moves' do
        it 'updates castling_rights correctly' do
          source = :a1
          destination = :a3
          result = special_moves.update_castling_rights(source, destination, castling_rights)
          expected_result = 'Kkq'
          expect(result).to eq(expected_result)
        end
      end

      context 'when king side rook moves' do
        it 'updates castling_rights correctly' do
          source = :h1
          destination = :h6
          result = special_moves.update_castling_rights(source, destination, castling_rights)
          expected_result = 'Qkq'
          expect(result).to eq(expected_result)
        end
      end

      context 'when king moves' do
        it 'updates castling_rights correctly' do
          source = :e1
          destination = :f2
          result = special_moves.update_castling_rights(source, destination, castling_rights)
          expected_result = 'kq'
          expect(result).to eq(expected_result)
        end
      end
    end

    context 'for black' do
      context 'when queen side rook moves' do
        it 'updates castling_rights correctly' do
          source = :a8
          destination = :a6
          result = special_moves.update_castling_rights(source, destination, castling_rights)
          expected_result = 'KQk'
          expect(result).to eq(expected_result)
        end
      end

      context 'when king side rook moves' do
        it 'updates castling_rights correctly' do
          source = :h8
          destination = :h6
          result = special_moves.update_castling_rights(source, destination, castling_rights)
          expected_result = 'KQq'
          expect(result).to eq(expected_result)
        end
      end

      context 'when king moves' do
        it 'updates castling_rights correctly' do
          source = :e8
          destination = :f7
          result = special_moves.update_castling_rights(source, destination, castling_rights)
          expected_result = 'KQ'
          expect(result).to eq(expected_result)
        end
      end
    end

    context 'when rook captures rook' do
      context 'queen side' do
        it 'updates castling_rights correctly' do
          source = :a1
          destination = :a8
          result = special_moves.update_castling_rights(source, destination, castling_rights)
          expected_result = 'Kk'
          expect(result).to eq(expected_result)
        end
      end

      context 'king side' do
        it 'updates castling_rights correctly' do
          source = :h8
          destination = :h1
          result = special_moves.update_castling_rights(source, destination, castling_rights)
          expected_result = 'Qq'
          expect(result).to eq(expected_result)
        end
      end
    end

    context 'when other piece captures rook' do
      context 'for white' do
        context 'for queen side rook' do
          it 'updates castling_rights correctly' do
            source = :c3
            destination = :a1
            result = special_moves.update_castling_rights(source, destination, castling_rights)
            expected_result = 'Kkq'
            expect(result).to eq(expected_result)
          end
        end

        context 'for king side rook' do
          it 'updates castling_rights correctly' do
            source = :f3
            destination = :h1
            result = special_moves.update_castling_rights(source, destination, castling_rights)
            expected_result = 'Qkq'
            expect(result).to eq(expected_result)
          end
        end
      end

      context 'for black' do
        context 'for queen side rook' do
          it 'updates castling_rights correctly' do
            source = :c6
            destination = :a8
            result = special_moves.update_castling_rights(source, destination, castling_rights)
            expected_result = 'KQk'
            expect(result).to eq(expected_result)
          end
        end

        context 'for king side rook' do
          it 'updates castling_rights correctly' do
            source = :f6
            destination = :h8
            result = special_moves.update_castling_rights(source, destination, castling_rights)
            expected_result = 'KQq'
            expect(result).to eq(expected_result)
          end
        end
      end
    end

    context 'when castling_rights empty' do
      let(:castling_rights) { '' }

      it 'returns empty castling_rights' do
        source = :h8
        destination = :h1
        result = special_moves.update_castling_rights(source, destination, castling_rights)
        expected_result = ''
        expect(result).to eq(expected_result)
      end
    end
  end

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

  describe '#satisfy_en_passant_conditions?' do
    let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb6/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    context 'when piece is not a pawn' do
      it 'returns false' do
        source = :b8
        destination = :c6
        result = special_moves.satisfy_en_passant_conditions?(source, destination, board)
        expect(result).to eq(false)
      end
    end

    context 'when the move is not a double step' do
      it 'returns false' do
        source = :h2
        destination = :h3
        result = special_moves.satisfy_en_passant_conditions?(source, destination, board)
        expect(result).to eq(false)
      end
    end

    context 'when piece is a pawn and move is a double step' do
      it 'returns true' do
        source = :e2
        destination = :e4
        result = special_moves.satisfy_en_passant_conditions?(source, destination, board)
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
        result = special_moves.white_pawn_double_step?(source, destination, board)
        expect(result).to eq(true)
      end
    end

    context 'when the move is not a double step' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/P7/1P6/2PPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns false' do
        source = :b2
        destination = :b3
        result = special_moves.white_pawn_double_step?(source, destination, board)
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
        result = special_moves.black_pawn_double_step?(source, destination, board)
        expect(result).to eq(true)
      end
    end

    context 'when the move is not a double step' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2PPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns false' do
        source = :g7
        destination = :g6
        result = special_moves.black_pawn_double_step?(source, destination, board)
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
        result = special_moves.en_passant_move_of_source(source, board)
        expected_result = :e3
        expect(result).to eq(expected_result)
      end
    end

    context 'for black piece' do
      let(:fen) { 'rnbqkbnr/pppp1p1p/6p1/4p3/P7/1P6/2P1PPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns correct en_passant move cell marker' do
        source = :b7
        result = special_moves.en_passant_move_of_source(source, board)
        expected_result = :b6
        expect(result).to eq(expected_result)
      end
    end
  end
end
