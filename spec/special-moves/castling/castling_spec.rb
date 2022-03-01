#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/special-moves/castling/castling'
require_relative '../../../lib/fen/fen-processor'
require_relative '../../../lib/board/utils/board-creator'

describe Castling do
  subject(:castling) { described_class.new }
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
          result = castling.update_castling_rights(source, destination, castling_rights)
          expected_result = 'Kkq'
          expect(result).to eq(expected_result)
        end
      end

      context 'when king side rook moves' do
        it 'updates castling_rights correctly' do
          source = :h1
          destination = :h6
          result = castling.update_castling_rights(source, destination, castling_rights)
          expected_result = 'Qkq'
          expect(result).to eq(expected_result)
        end
      end

      context 'when king moves' do
        it 'updates castling_rights correctly' do
          source = :e1
          destination = :f2
          result = castling.update_castling_rights(source, destination, castling_rights)
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
          result = castling.update_castling_rights(source, destination, castling_rights)
          expected_result = 'KQk'
          expect(result).to eq(expected_result)
        end
      end

      context 'when king side rook moves' do
        it 'updates castling_rights correctly' do
          source = :h8
          destination = :h6
          result = castling.update_castling_rights(source, destination, castling_rights)
          expected_result = 'KQq'
          expect(result).to eq(expected_result)
        end
      end

      context 'when king moves' do
        it 'updates castling_rights correctly' do
          source = :e8
          destination = :f7
          result = castling.update_castling_rights(source, destination, castling_rights)
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
          result = castling.update_castling_rights(source, destination, castling_rights)
          expected_result = 'Kk'
          expect(result).to eq(expected_result)
        end
      end

      context 'king side' do
        it 'updates castling_rights correctly' do
          source = :h8
          destination = :h1
          result = castling.update_castling_rights(source, destination, castling_rights)
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
            result = castling.update_castling_rights(source, destination, castling_rights)
            expected_result = 'Kkq'
            expect(result).to eq(expected_result)
          end
        end

        context 'for king side rook' do
          it 'updates castling_rights correctly' do
            source = :f3
            destination = :h1
            result = castling.update_castling_rights(source, destination, castling_rights)
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
            result = castling.update_castling_rights(source, destination, castling_rights)
            expected_result = 'KQk'
            expect(result).to eq(expected_result)
          end
        end

        context 'for king side rook' do
          it 'updates castling_rights correctly' do
            source = :f6
            destination = :h8
            result = castling.update_castling_rights(source, destination, castling_rights)
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
        result = castling.update_castling_rights(source, destination, castling_rights)
        expected_result = ''
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#castling_move' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    context 'when castling_rights empty' do
      it 'returns available castlings' do
        moves = []
        source = :e1
        castling_rights = ''
        color = 'white'
        result = castling.castling_move(moves, board, source, castling_rights, color)
        expect(result).to eq([])
      end
    end

    context 'when color don\'t have castling moves' do
      let(:fen) { 'r1p1k1pr/b7/8/8/8/8/8/R3K2R b KQkq - 0 1' }

      it 'returns available castlings' do
        moves = %i[d7 e7 f7 d8 f8]
        source = :e8
        castling_rights = 'KQkq'
        color = 'black'
        result = castling.castling_move(moves, board, source, castling_rights, color)
        expect(result).to eq([])
      end
    end

    context 'when adjacent moves not available' do
      let(:fen) { 'r2pkp1r/b7/8/8/8/8/8/R3K2R b KQkq - 0 1' }

      it 'returns available castlings' do
        moves = %i[d7 e7 f7]
        source = :e8
        castling_rights = 'KQkq'
        color = 'black'
        result = castling.castling_move(moves, board, source, castling_rights, color)
        expect(result).to eq([])
      end
    end

    context 'when cells between rook and king not empty' do
      let(:fen) { 'rp2k1pr/b7/8/8/8/8/8/R3K2R b KQkq - 0 1' }

      it 'returns available castlings' do
        moves = %i[d7 e7 f7 d8 f8]
        source = :e8
        castling_rights = 'KQkq'
        color = 'black'
        result = castling.castling_move(moves, board, source, castling_rights, color)
        expect(result).to eq([])
      end
    end

    context 'when all conditions met' do
      let(:fen) { 'rp2k1pr/b7/8/8/8/8/8/R3K2R b KQkq - 0 1' }

      it 'returns available castlings' do
        moves = %i[d1 f1 d2 e2 f2]
        source = :e1
        castling_rights = 'KQkq'
        color = 'white'
        result = castling.castling_move(moves, board, source, castling_rights, color)
        expect(result).to eq(%i[g1 c1])
      end
    end
  end

  describe '#cells_between_king_and_rook_empty?' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    context 'for white' do
      context 'when moves between queen side rook and king empty' do
        let(:fen) { 'rp2k2r/b7/8/8/8/8/8/R3K1pR b KQkq - 0 1' }

        it 'returns true' do
          source = :e1
          castling_move = :c1
          color = 'white'
          result = castling.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(true)
        end
      end

      context 'when moves between king side rook and king empty' do
        let(:fen) { 'rp2k2r/b7/8/8/8/8/8/R1p1K2R b KQkq - 0 1' }

        it 'returns true' do
          source = :e1
          castling_move = :g1
          color = 'white'
          result = castling.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(true)
        end
      end

      context 'when moves between queen side rook and king not empty' do
        let(:fen) { 'rp2k2r/b7/8/8/8/8/8/R1p1K2R b KQkq - 0 1' }

        it 'returns false' do
          source = :e1
          castling_move = :c1
          color = 'white'
          result = castling.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(false)
        end
      end

      context 'when moves between king side rook and king notempty' do
        let(:fen) { 'rp2k2r/b7/8/8/8/8/8/R3K1pR b KQkq - 0 1' }

        it 'returns false' do
          source = :e1
          castling_move = :g1
          color = 'white'
          result = castling.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(false)
        end
      end
    end

    context 'for black' do
      context 'when moves between queen side rook and king empty' do
        let(:fen) { 'r3k1pr/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

        it 'returns true' do
          source = :e8
          castling_move = :c8
          color = 'black'
          result = castling.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(true)
        end
      end

      context 'when moves between king side rook and king empty' do
        let(:fen) { 'rp2k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

        it 'returns true' do
          source = :e8
          castling_move = :g8
          color = 'black'
          result = castling.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(true)
        end
      end

      context 'when moves between queen side rook and king not empty' do
        let(:fen) { 'rp2k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

        it 'returns false' do
          source = :e8
          castling_move = :c8
          color = 'black'
          result = castling.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(false)
        end
      end

      context 'when moves between king side rook and king not empty' do
        let(:fen) { 'r3k1pr/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

        it 'returns false' do
          source = :e8
          castling_move = :g8
          color = 'black'
          result = castling.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(false)
        end
      end
    end
  end

  describe '#rook_cell' do
    context 'for white' do
      let(:color) { 'white' }

      context 'for castling move c1' do
        it 'returns :a1' do
          castling_move = :c1
          result = castling.rook_cell(color, castling_move)
          expect(result).to eq(:a1)
        end
      end

      context 'for castling move g1' do
        it 'returns :h1' do
          castling_move = :g1
          result = castling.rook_cell(color, castling_move)
          expect(result).to eq(:h1)
        end
      end
    end

    context 'for black' do
      let(:color) { 'black' }

      context 'for castling move c8' do
        it 'returns :a8' do
          castling_move = :c8
          result = castling.rook_cell(color, castling_move)
          expect(result).to eq(:a8)
        end
      end

      context 'for castling move g8' do
        it 'returns :h8' do
          castling_move = :g8
          result = castling.rook_cell(color, castling_move)
          expect(result).to eq(:h8)
        end
      end
    end
  end

  describe '#castling_has_adjacent_move?' do
    context 'when castling has adjacent move' do
      it 'returns true' do
        moves = %i[a8 c8]
        adjacent_move = :c8
        result = castling.castling_has_adjacent_move?(moves, adjacent_move)
        expect(result).to eq(true)
      end
    end

    context 'when castling don\'t have adjacent move' do
      it 'returns false' do
        moves = %i[a8 c8]
        adjacent_move = :b8
        result = castling.castling_has_adjacent_move?(moves, adjacent_move)
        expect(result).to eq(false)
      end
    end
  end

  describe '#adjacent_move' do
    let(:fen) { 'rp2k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    context 'for queen side castling' do
      it 'returns adjacent move' do
        castling_move = :g8
        result = castling.adjacent_move(castling_move, board)
        expect(result).to eq(:f8)
      end
    end

    context 'for king side castling' do
      it 'returns adjacent move' do
        castling_move = :c1
        result = castling.adjacent_move(castling_move, board)
        expect(result).to eq(:d1)
      end
    end
  end

  describe '#queen_side_castling?' do
    context 'for queen side castling' do
      it 'returns true' do
        castling_move = :c1
        result = castling.queen_side_castling?(castling_move)
        expect(result).to eq(true)
      end
    end

    context 'for king side castling' do
      it 'returns false' do
        castling_move = :g1
        result = castling.queen_side_castling?(castling_move)
        expect(result).to eq(false)
      end
    end
  end

  describe '#castlings_of_color' do
    context 'for white' do
      let(:color) { 'white' }

      context 'for right KQkq' do
        it 'returns valid rights' do
          result = castling.castlings_of_color(color, 'KQkq')
          expect(result).to eq(%i[g1 c1])
        end
      end

      context 'for right KQ' do
        it 'returns valid rights' do
          result = castling.castlings_of_color(color, 'KQ')
          expect(result).to eq(%i[g1 c1])
        end
      end

      context 'for right kq' do
        it 'returns valid rights' do
          result = castling.castlings_of_color(color, 'kq')
          expect(result).to eq([])
        end
      end

      context 'for empty right' do
        it 'returns valid rights' do
          result = castling.castlings_of_color(color, '')
          expect(result).to eq([])
        end
      end
    end

    context 'for black' do
      let(:color) { 'black' }

      context 'for right KQkq' do
        it 'returns valid rights' do
          result = castling.castlings_of_color(color, 'KQkq')
          expect(result).to eq(%i[g8 c8])
        end
      end

      context 'for right KQ' do
        it 'returns valid rights' do
          result = castling.castlings_of_color(color, 'KQ')
          expect(result).to eq([])
        end
      end

      context 'for right kq' do
        it 'returns valid rights' do
          result = castling.castlings_of_color(color, 'kq')
          expect(result).to eq(%i[g8 c8])
        end
      end

      context 'for empty right' do
        it 'returns valid rights' do
          result = castling.castlings_of_color(color, '')
          expect(result).to eq([])
        end
      end
    end
  end
end
