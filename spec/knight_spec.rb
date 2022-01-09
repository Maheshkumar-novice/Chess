#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe 'Knight' do
  describe 'Board#create_moves' do
    subject(:board) { Board.new }

    context 'with default fen board' do
      it 'returns all the moves of white knight from b1' do
        cell = :b1
        result = board.create_moves(cell).sort
        expected_result = %i[a3 c3 d2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black knight from g8' do
        cell = :g8
        result = board.create_moves(cell).sort
        expected_result = %i[h6 f6 e7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7'
      end

      it 'returns all the moves of white knight from e2' do
        cell = :e2
        result = board.create_moves(cell).sort
        expected_result = %i[d4 f4 c3 c1 g3 g1].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black knight from c6' do
        cell = :c6
        result = board.create_moves(cell).sort
        expected_result = %i[b4 d4 e5 e7 d8 b8 a5 a7].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
