#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'

describe Bishop do
  describe '#create_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the moves of white bishop from f1' do
        cell = :f1
        bishop = board[cell].piece
        result = bishop.create_moves(board).sort
        expected_result = %i[g2 e2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black bishop from c8' do
        cell = :c8
        bishop = board[cell].piece
        result = bishop.create_moves(board).sort
        expected_result = %i[d7 b7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7'
      end

      it 'returns all the moves of white bishop from d2' do
        cell = :d2
        bishop = board[cell].piece
        result = bishop.create_moves(board).sort
        expected_result = %i[a5 b4 c1 c3 e1 e3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black bishop from b7' do
        cell = :b7
        bishop = board[cell].piece
        result = bishop.create_moves(board).sort
        expected_result = %i[a6 a8 c6 c8].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the classified moves of white bishop c1' do
        cell = :c1
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: [], empty: [] }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black bishop f8' do
        cell = :f8
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: [], empty: [] }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnk2bnr/p1p2ppp/1p1qp1N1/2Bp1b2/3P4/1PP5/P1Q1PPPP/RN2KB1R b KQ - 1 9'
      end

      it 'returns all the classified moves of white bishop f5' do
        cell = :f5
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: %i[e6 g6], empty: %i[g4 h3] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black bishop c5' do
        cell = :c5
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: %i[b6 f2], empty: %i[d4 e3 b4 a3] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
