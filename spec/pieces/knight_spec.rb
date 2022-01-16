#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'

describe Knight do
  describe '#create_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the moves of white knight from b1' do
        cell = :b1
        knight = board[cell].piece
        result = knight.create_moves(board).sort
        expected_result = %i[a3 c3 d2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black knight from g8' do
        cell = :g8
        knight = board[cell].piece
        result = knight.create_moves(board).sort
        expected_result = %i[h6 f6 e7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7'
      end

      it 'returns all the moves of white knight from d2' do
        cell = :d2
        knight = board[cell].piece
        result = knight.create_moves(board).sort
        expected_result = %i[c4 e4 f1 f3 b1 b3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black knight from f6' do
        cell = :f6
        knight = board[cell].piece
        result = knight.create_moves(board).sort
        expected_result = %i[e8 g8 h7 h5 e4 g4 d5 d7].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the classified moves of white knight b1' do
        cell = :b1
        knight = board[cell].piece
        moves = knight.create_moves(board)
        result = knight.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[a3 c3] }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black knight g8' do
        cell = :g8
        knight = board[cell].piece
        moves = knight.create_moves(board)
        result = knight.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[h6 f6] }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'r1k2bnr/p1p2ppp/1p2p1N1/2Bpqb2/1n1P4/1PPQ4/P3PPPP/RN2KB1R b KQ - 7 12'
      end

      it 'returns all the classified moves of white knight g6' do
        cell = :g6
        knight = board[cell].piece
        moves = knight.create_moves(board)
        result = knight.classify_moves(moves, board)
        expected_result = { captures: %i[f8 h8 e5], empty: %i[e7 f4 h4] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black knight b4' do
        cell = :b4
        knight = board[cell].piece
        moves = knight.create_moves(board)
        result = knight.classify_moves(moves, board)
        expected_result = { captures: %i[d3 a2], empty: %i[c2 a6 c6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end
end
