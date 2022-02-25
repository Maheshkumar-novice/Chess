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

  describe '#castling_move' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    context 'when castling_rights empty' do
      it 'returns available castlings' do
        moves = []
        source = :e1
        castling_rights = ''
        color = 'white'
        result = special_moves.castling_move(moves, board, source, castling_rights, color)
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
        result = special_moves.castling_move(moves, board, source, castling_rights, color)
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
        result = special_moves.castling_move(moves, board, source, castling_rights, color)
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
        result = special_moves.castling_move(moves, board, source, castling_rights, color)
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
        result = special_moves.castling_move(moves, board, source, castling_rights, color)
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
          result = special_moves.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(true)
        end
      end

      context 'when moves between king side rook and king empty' do
        let(:fen) { 'rp2k2r/b7/8/8/8/8/8/R1p1K2R b KQkq - 0 1' }

        it 'returns true' do
          source = :e1
          castling_move = :g1
          color = 'white'
          result = special_moves.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(true)
        end
      end

      context 'when moves between queen side rook and king not empty' do
        let(:fen) { 'rp2k2r/b7/8/8/8/8/8/R1p1K2R b KQkq - 0 1' }

        it 'returns false' do
          source = :e1
          castling_move = :c1
          color = 'white'
          result = special_moves.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(false)
        end
      end

      context 'when moves between king side rook and king notempty' do
        let(:fen) { 'rp2k2r/b7/8/8/8/8/8/R3K1pR b KQkq - 0 1' }

        it 'returns false' do
          source = :e1
          castling_move = :g1
          color = 'white'
          result = special_moves.cells_between_king_and_rook_empty?(source, castling_move, board, color)
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
          result = special_moves.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(true)
        end
      end

      context 'when moves between king side rook and king empty' do
        let(:fen) { 'rp2k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

        it 'returns true' do
          source = :e8
          castling_move = :g8
          color = 'black'
          result = special_moves.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(true)
        end
      end

      context 'when moves between queen side rook and king not empty' do
        let(:fen) { 'rp2k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

        it 'returns false' do
          source = :e8
          castling_move = :c8
          color = 'black'
          result = special_moves.cells_between_king_and_rook_empty?(source, castling_move, board, color)
          expect(result).to eq(false)
        end
      end

      context 'when moves between king side rook and king not empty' do
        let(:fen) { 'r3k1pr/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

        it 'returns false' do
          source = :e8
          castling_move = :g8
          color = 'black'
          result = special_moves.cells_between_king_and_rook_empty?(source, castling_move, board, color)
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
          result = special_moves.rook_cell(color, castling_move)
          expect(result).to eq(:a1)
        end
      end

      context 'for castling move g1' do
        it 'returns :h1' do
          castling_move = :g1
          result = special_moves.rook_cell(color, castling_move)
          expect(result).to eq(:h1)
        end
      end
    end

    context 'for black' do
      let(:color) { 'black' }

      context 'for castling move c8' do
        it 'returns :a8' do
          castling_move = :c8
          result = special_moves.rook_cell(color, castling_move)
          expect(result).to eq(:a8)
        end
      end

      context 'for castling move g8' do
        it 'returns :h8' do
          castling_move = :g8
          result = special_moves.rook_cell(color, castling_move)
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
        result = special_moves.castling_has_adjacent_move?(moves, adjacent_move)
        expect(result).to eq(true)
      end
    end

    context 'when castling don\'t have adjacent move' do
      it 'returns false' do
        moves = %i[a8 c8]
        adjacent_move = :b8
        result = special_moves.castling_has_adjacent_move?(moves, adjacent_move)
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
        result = special_moves.adjacent_move(castling_move, board)
        expect(result).to eq(:f8)
      end
    end

    context 'for king side castling' do
      it 'returns adjacent move' do
        castling_move = :c1
        result = special_moves.adjacent_move(castling_move, board)
        expect(result).to eq(:d1)
      end
    end
  end

  describe '#queen_side_castling?' do
    context 'for queen side castling' do
      it 'returns true' do
        castling_move = :c1
        result = special_moves.queen_side_castling?(castling_move)
        expect(result).to eq(true)
      end
    end

    context 'for king side castling' do
      it 'returns false' do
        castling_move = :g1
        result = special_moves.queen_side_castling?(castling_move)
        expect(result).to eq(false)
      end
    end
  end

  describe '#castlings_of_color' do
    context 'for white' do
      let(:color) { 'white' }

      context 'for right KQkq' do
        it 'returns valid rights' do
          result = special_moves.castlings_of_color(color, 'KQkq')
          expect(result).to eq(%i[g1 c1])
        end
      end

      context 'for right KQ' do
        it 'returns valid rights' do
          result = special_moves.castlings_of_color(color, 'KQ')
          expect(result).to eq(%i[g1 c1])
        end
      end

      context 'for right kq' do
        it 'returns valid rights' do
          result = special_moves.castlings_of_color(color, 'kq')
          expect(result).to eq([])
        end
      end

      context 'for empty right' do
        it 'returns valid rights' do
          result = special_moves.castlings_of_color(color, '')
          expect(result).to eq([])
        end
      end
    end

    context 'for black' do
      let(:color) { 'black' }

      context 'for right KQkq' do
        it 'returns valid rights' do
          result = special_moves.castlings_of_color(color, 'KQkq')
          expect(result).to eq(%i[g8 c8])
        end
      end

      context 'for right KQ' do
        it 'returns valid rights' do
          result = special_moves.castlings_of_color(color, 'KQ')
          expect(result).to eq([])
        end
      end

      context 'for right kq' do
        it 'returns valid rights' do
          result = special_moves.castlings_of_color(color, 'kq')
          expect(result).to eq(%i[g8 c8])
        end
      end

      context 'for empty right' do
        it 'returns valid rights' do
          result = special_moves.castlings_of_color(color, '')
          expect(result).to eq([])
        end
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
