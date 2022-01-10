#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe 'Bishop' do
  describe 'Board#create_moves' do
    subject(:board) { Board.new }

    context 'with default fen board' do
      it 'returns all the moves of white bishop from f1' do
        cell = :f1
        result = board.create_moves(cell).sort
        expected_result = %i[g2 e2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black bishop from c8' do
        cell = :c8
        result = board.create_moves(cell).sort
        expected_result = %i[d7 b7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7'
      end

      it 'returns all the moves of white bishop from d2' do
        cell = :d2
        result = board.create_moves(cell).sort
        expected_result = %i[a5 b4 c1 c3 e1 e3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black bishop from b7' do
        cell = :b7
        result = board.create_moves(cell).sort
        expected_result = %i[a6 a8 c6 c8].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe 'Board#classify_moves' do
    subject(:board) { Board.new }
    let(:result) { board.classify_moves(cell, board.create_moves(cell)) }

    context 'with default fen board' do
      context 'when moves of white bishop c1 are classified' do
        let(:cell) { :c1 }

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

      context 'when moves of black bishop f8 are classified' do
        let(:cell) { :f8 }

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

    context 'with custom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnk2bnr/p1p2ppp/1p1qp1N1/2Bp1b2/3P4/1PP5/P1Q1PPPP/RN2KB1R b KQ - 1 9'
      end

      context 'when moves of white bishop f5 are classified' do
        let(:cell) { :f5 }

        it 'returns all the empty moves' do
          empty = result[:empty].sort
          expected_result = %i[g4 h3].sort
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures].sort
          expected_result = %i[e6 g6].sort
          expect(captures).to eq(expected_result)
        end
      end

      context 'when moves of black bishop c5 are classified' do
        let(:cell) { :c5 }

        it 'returns all the empty moves' do
          empty = result[:empty].sort
          expected_result = %i[d4 e3 b4 a3].sort
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures].sort
          expected_result = %i[f2 b6].sort
          expect(captures).to eq(expected_result)
        end
      end
    end
  end
end
