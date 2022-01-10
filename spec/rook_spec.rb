#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe 'Rook' do
  describe 'Board#create_moves' do
    subject(:board) { Board.new }

    context 'with default fen board' do
      it 'returns all the moves of white rook from a1' do
        cell = :a1
        result = board.create_moves(cell).sort
        expected_result = %i[a2 b1].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black rook from h8' do
        cell = :h8
        result = board.create_moves(cell).sort
        expected_result = %i[h7 g8].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7'
      end

      it 'returns all the moves of white rook from h1' do
        cell = :h1
        result = board.create_moves(cell).sort
        expected_result = %i[g1 f1 h2 h3 h4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black rook from a8' do
        cell = :a8
        result = board.create_moves(cell).sort
        expected_result = %i[a7 a6 a5 a4 b8 c8 d8].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe 'Board#classify_moves' do
    subject(:board) { Board.new }
    let(:result) { board.classify_moves(cell, board.create_moves(cell)) }

    context 'with default fen board' do
      context 'when moves of white rook h1 are classified' do
        let(:cell) { :h1 }

        it 'returns all the empty moves' do
          empty = result[:empty]
          expected_result = []
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures]
          expected_result = []
          expect(captures).to eq(expected_result)
        end
      end

      context 'when moves of black rook a8 are classified' do
        let(:cell) { :a8 }

        it 'returns all the empty moves' do
          empty = result[:empty]
          expected_result = []
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures]
          expected_result = []
          expect(captures).to eq(expected_result)
        end
      end
    end

    context 'with cusom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnb1kbn1/2p1ppp1/1p6/pPP2r1p/P2pPQ2/3R2qP/3P1PP1/1NB1KBNR b Kq - 4 11'
      end

      context 'when moves of white rook e3 are classified' do
        let(:cell) { :e3 }

        it 'returns all the empty moves' do
          empty = result[:empty].sort
          expected_result = %i[d3 c3 f3 g3 h3].sort
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures].sort
          expected_result = %i[b3 e4].sort
          expect(captures).to eq(expected_result)
        end
      end

      context 'when moves of black rook c5 are classified' do
        let(:cell) { :c5 }

        it 'returns all the empty moves' do
          empty = result[:empty].sort
          expected_result = %i[b5 d5 e5 c6].sort
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures].sort
          expected_result = %i[f5 c4].sort
          expect(captures).to eq(expected_result)
        end
      end
    end
  end
end
