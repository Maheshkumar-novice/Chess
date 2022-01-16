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

      it 'returns all the moves of white queen from f5' do
        cell = :f5
        queen = board[cell].piece
        result = queen.create_moves(board).sort
        expected_result = %i[a5 b5 c5 d5 e5 g5 h5 f6 f7 f4 f3 f2 e6 d7 g6 h7 e4 d3 c2 g4 h3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black queen from d4' do
        cell = :d4
        queen = board[cell].piece
        result = queen.create_moves(board).sort
        expected_result = %i[c4 e4 f4 g4 h4 d7 d6 d5 d2 d3 a7 b6 c5 e3 g7 f6 e5 a1 b2 c3].sort
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

      it 'returns all the classified moves of black queen from e8' do
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

      it 'returns all the classified moves of white queen from e5' do
        cell = :e5
        queen = board[cell].piece
        moves = queen.create_moves(board)
        result = queen.classify_moves(moves, board)
        expected_result = { captures: %i[e6 d5 f5 c7 g7], empty: %i[d6 f6 e4 e3 f4 g3 h2] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black queen from f3' do
        cell = :f3
        queen = board[cell].piece
        moves = queen.create_moves(board)
        result = queen.classify_moves(moves, board)
        expected_result = { captures: %i[e2 f2 g2 h3 d3], empty: %i[e4 f4 g4 e3 g3 h5] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
