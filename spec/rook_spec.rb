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
        expected_result = %i[g1 f1 e1 h2 h3 h4 h5].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black rook from a8' do
        cell = :a8
        result = board.create_moves(cell).sort
        expected_result = %i[a7 a6 a5 b8 c8].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
