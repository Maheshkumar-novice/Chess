#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe 'King' do
  describe 'Board#create_moves' do
    subject(:board) { Board.new }

    context 'with default fen board' do
      it 'returns all the moves of white king from d1' do
        cell = :d1
        result = board.create_moves(cell).sort
        expected_result = %i[e1 c1 c2 d2 e2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black king from d8' do
        cell = :d8
        result = board.create_moves(cell).sort
        expected_result = %i[c8 e8 c7 d7 e7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnb2bnr/pp1p1ppp/8/3k4/1P1P1P2/2pK4/P1PP2PP/RNB2BNR b - - 1 11'
      end

      it 'returns all the moves of white king from e3' do
        cell = :e3
        result = board.create_moves(cell).sort
        expected_result = %i[f3 d3 d2 e2 f2 d4 e4 f4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black king from e5' do
        cell = :e5
        result = board.create_moves(cell).sort
        expected_result = %i[d6 e6 f6 d5 f5 d4 e4 f4].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
