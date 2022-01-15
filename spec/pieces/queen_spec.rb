#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'

describe Queen do
  describe '#create_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the moves of white queen from e1' do
        cell = :e1
        queen = board[cell].piece
        result = queen.create_moves(board).sort
        expected_result = %i[d1 f1 d2 f2 e2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black queen from e8' do
        cell = :e8
        queen = board[cell].piece
        result = queen.create_moves(board).sort
        expected_result = %i[d7 f7 e7 d8 f8].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnb1kbnr/pp1ppppp/8/5Q2/1Ppq4/4P3/P1PP1PPP/RNB1KBNR w KQkq - 2 5'
      end

      it 'returns all the moves of white queen from c5' do
        cell = :c5
        queen = board[cell].piece
        result = queen.create_moves(board).sort
        expected_result = %i[c4 c3 c2 c6 c7 b5 a5 d5 e5 f5 g5 h5 b6 a7 d4 e3 f2 b4 a3 d6 e7].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black queen from e4' do
        cell = :e4
        queen = board[cell].piece
        result = queen.create_moves(board).sort
        expected_result = %i[a4 b4 c4 d4 f4 e3 e2 e5 e6 e7 d3 f5 g6 h7 d5 c6 b7 f3 g2 h1].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the classified moves of white queen from e1' do
        cell = :e1
        queen = board[cell].piece
        moves = queen.create_moves(board)
        result = queen.classify_moves(moves, board)
        expected_result = { captures: [], empty: [] }
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black queen from e8' do
        cell = :e8
        queen = board[cell].piece
        moves = queen.create_moves(board)
        result = queen.classify_moves(moves, board)
        expected_result = { captures: [], empty: [] }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'r1k3nr/p1p1bpp1/2n1p1Np/1pBpQb2/3P4/NPPR1q1P/P3PPP1/4KB1R b K - 2 18'
      end

      it 'returns all the moves of white queen from d5' do
        cell = :d5
        queen = board[cell].piece
        moves = queen.create_moves(board)
        result = queen.classify_moves(moves, board)
        expected_result = { captures: %i[c5 e5 d6 f7 b7], empty: %i[d4 d3 c6 c4 b3 a2 e6] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black queen from c3' do
        cell = :c3
        queen = board[cell].piece
        moves = queen.create_moves(board)
        result = queen.classify_moves(moves, board)
        expected_result = { captures: %i[b2 d2 c2 e3 a3], empty: %i[b3 d3 b4 a5 d4 c4] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
