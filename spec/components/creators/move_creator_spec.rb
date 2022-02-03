#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/components/creators/move-creator'
require_relative '../../../lib/components/creators/board-creator'
require_relative '../../../lib/board/fen-processor'

describe MoveCreator do
  subject(:move_creator) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  let(:fen) { '2q1kb1r/pp1p1ppp/n1p1pn2/1r1b2B1/4P3/2PP2RP/PP2P1P1/RN1QKBN1 w Qk - 0 1' }
  let(:board) { board_creator.create_board(fen_processor.pieces) }
  before { fen_processor.process(fen) }

  describe '#horizontal_moves' do
    context 'for cell b5' do
      let(:cell) { :b5 }

      it 'returns all the horizontal moves' do
        result = move_creator.horizontal_moves(cell, board).sort
        expected_result = %i[a5 c5 d5].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell g3' do
      let(:cell) { :g3 }

      it 'returns all the horizontal moves' do
        result = move_creator.horizontal_moves(cell, board).sort
        expected_result = %i[d3 e3 f3 h3].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell d5' do
      let(:cell) { :d5 }

      it 'returns all the horizontal moves' do
        result = move_creator.horizontal_moves(cell, board).sort
        expected_result = %i[c5 b5 e5 f5 g5].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#vertical_moves' do
    context 'for cell b5' do
      let(:cell) { :b5 }

      it 'returns all the vertical moves' do
        result = move_creator.vertical_moves(cell, board).sort
        expected_result = %i[b6 b7 b2 b3 b4].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell c8' do
      let(:cell) { :c8 }

      it 'returns all the vertical moves' do
        result = move_creator.vertical_moves(cell, board).sort
        expected_result = %i[c7 c6].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell e4' do
      let(:cell) { :e4 }

      it 'returns all the vertical moves' do
        result = move_creator.vertical_moves(cell, board).sort
        expected_result = %i[e3 e2 e5 e6].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell c1' do
      let(:cell) { :c1 }

      it 'returns all the vertical moves' do
        result = move_creator.vertical_moves(cell, board).sort
        expected_result = %i[c2 c3].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#diagonal_moves' do
    context 'for cell d5' do
      let(:cell) { :d5 }

      it 'returns all the diagonal moves' do
        result = move_creator.diagonal_moves(cell, board).sort
        expected_result = %i[c6 e6 a2 b3 c4 e4].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell f8' do
      let(:cell) { :f8 }

      it 'returns all the diagonal moves' do
        result = move_creator.diagonal_moves(cell, board).sort
        expected_result = %i[a3 b4 c5 d6 e7 g7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell f6' do
      let(:cell) { :f6 }

      it 'returns all the diagonal moves' do
        result = move_creator.diagonal_moves(cell, board).sort
        expected_result = %i[d8 e7 g7 g5 e5 d4 c3].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#rook_moves' do
    context 'for cell b5' do
      let(:cell) { :b5 }

      it 'returns all the rook moves' do
        result = move_creator.rook_moves(cell, board).sort
        expected_result = %i[a5 b2 b3 b4 b6 b7 c5 d5].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell g3' do
      let(:cell) { :g3 }

      it 'returns all the rook moves' do
        result = move_creator.rook_moves(cell, board).sort
        expected_result = %i[d3 e3 f3 h3 g4 g5 g2].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell h8' do
      let(:cell) { :h8 }

      it 'returns all the rook moves' do
        result = move_creator.rook_moves(cell, board).sort
        expected_result = %i[g8 f8 h7].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#knight_moves' do
    context 'for cell b1' do
      let(:cell) { :b1 }

      it 'returns all the knight moves' do
        result = move_creator.knight_moves(cell, board).sort
        expected_result = %i[a3 c3 d2].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell a6' do
      let(:cell) { :a6 }

      it 'returns all the knight moves' do
        result = move_creator.knight_moves(cell, board).sort
        expected_result = %i[b8 c7 c5 b4].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell f6' do
      let(:cell) { :f6 }

      it 'returns all the knight moves' do
        result = move_creator.knight_moves(cell, board).sort
        expected_result = %i[e8 g8 h5 h7 e4 g4 d5 d7].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#bishop_moves' do
    context 'for cell g5' do
      let(:cell) { :g5 }

      it 'returns all the bishop moves' do
        result = move_creator.bishop_moves(cell, board).sort
        expected_result = %i[f6 h6 c1 d2 e3 f4 h4].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell f8' do
      let(:cell) { :f8 }

      it 'returns all the bishop moves' do
        result = move_creator.bishop_moves(cell, board).sort
        expected_result = %i[a3 b4 c5 d6 e7 g7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell f1' do
      let(:cell) { :f1 }

      it 'returns all the bishop moves' do
        result = move_creator.bishop_moves(cell, board).sort
        expected_result = %i[e2 g2].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#queen_moves' do
    context 'for cell d1' do
      let(:cell) { :d1 }

      it 'returns all the queen moves' do
        result = move_creator.queen_moves(cell, board).sort
        expected_result = %i[c1 b1 e1 d2 d3 c2 b3 a4 e2].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell c8' do
      let(:cell) { :c8 }

      it 'returns all the queen moves' do
        result = move_creator.queen_moves(cell, board).sort
        expected_result = %i[a8 b8 d8 e8 c7 c6 b7 d7].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#king_moves' do
    context 'for cell e1' do
      let(:cell) { :e1 }

      it 'returns all the king moves' do
        result = move_creator.king_moves(cell, board).sort
        expected_result = %i[d1 f1 d2 e2 f2].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell e8' do
      let(:cell) { :e8 }

      it 'returns all the king moves' do
        result = move_creator.king_moves(cell, board).sort
        expected_result = %i[d8 f8 d7 e7 f7].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#pawn_moves' do
    context 'for cell c3' do
      let(:cell) { :c3 }

      it 'returns all the white pawn moves' do
        result = move_creator.pawn_moves(cell, 'white', board).sort
        expected_result = %i[c4 b4 d4].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell b2' do
      let(:cell) { :b2 }

      it 'returns all the white pawn moves' do
        result = move_creator.pawn_moves(cell, 'white', board).sort
        expected_result = %i[a3 b3 c3 b4].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell e6' do
      let(:cell) { :e6 }

      it 'returns all the black pawn moves' do
        result = move_creator.pawn_moves(cell, 'black', board).sort
        expected_result = %i[e5 d5 f5].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'for cell h7' do
      let(:cell) { :h7 }

      it 'returns all the black pawn moves' do
        result = move_creator.pawn_moves(cell, 'black', board).sort
        expected_result = %i[h6 h5 g6].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
