#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe 'Queen' do
  describe 'Board#create_moves' do
    subject(:board) { Board.new }

    context 'with default fen board' do
      it 'returns all the moves of white queen from e1' do
        cell = :e1
        result = board.create_moves(cell).sort
        expected_result = %i[d1 f1 d2 f2 e2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black queen from e8' do
        cell = :e8
        result = board.create_moves(cell).sort
        expected_result = %i[d7 f7 e7 d8 f8].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnb1kbnr/pp1ppppp/8/5Q2/1Ppq4/4P3/P1PP1PPP/RNB1KBNR w KQkq - 2 5'
      end

      it 'returns all the moves of white queen from c5' do
        cell = :c5
        result = board.create_moves(cell).sort
        expected_result = %i[c4 c3 c2 c6 c7 b5 a5 d5 e5 f5 g5 h5 b6 a7 d4 e3 f2 b4 a3 d6 e7].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black queen from e4' do
        cell = :e4
        result = board.create_moves(cell).sort
        expected_result = %i[a4 b4 c4 d4 f4 e3 e2 e5 e6 e7 d3 f5 g6 h7 d5 c6 b7 f3 g2 h1].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe 'Board#classify_moves' do
    subject(:board) { Board.new }
    let(:result) { board.classify_moves(cell, board.create_moves(cell)) }

    context 'with default fen board' do
      context 'when moves of white queen e1 are classified' do
        let(:cell) { :e1 }

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

      context 'when moves of black queen e8 are classified' do
        let(:cell) { :e8 }

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
        'r1k3nr/p1p1bpp1/2n1p1Np/1pBpQb2/3P4/NPPR1q1P/P3PPP1/4KB1R b K - 2 18'
      end

      context 'when moves of white queen d5 are classified' do
        let(:cell) { :d5 }

        it 'returns all the empty moves' do
          empty = result[:empty].sort
          expected_result = %i[d4 d3 c6 c4 b3 a2 e6].sort
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures].sort
          expected_result = %i[c5 e5 d6 f7 b7].sort
          expect(captures).to eq(expected_result)
        end
      end

      context 'when moves of black queen c3 are classified' do
        let(:cell) { :c3 }

        it 'returns all the empty moves' do
          empty = result[:empty].sort
          expected_result = %i[b3 d3 b4 a5 d4 c4].sort
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures].sort
          expected_result = %i[b2 d2 c2 e3 a3].sort
          expect(captures).to eq(expected_result)
        end
      end
    end
  end
end
