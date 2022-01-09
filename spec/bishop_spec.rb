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
end
