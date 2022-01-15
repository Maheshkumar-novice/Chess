#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'

describe Rook do
  describe '#create_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the moves of white rook from a1' do
        cell = :a1
        rook = board[cell].piece
        result = rook.create_moves(board).sort
        expected_result = %i[a2 b1].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black rook from h8' do
        cell = :h8
        rook = board[cell].piece
        result = rook.create_moves(board).sort
        expected_result = %i[h7 g8].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7'
      end

      it 'returns all the moves of white rook from h1' do
        cell = :h1
        rook = board[cell].piece
        result = rook.create_moves(board).sort
        expected_result = %i[g1 f1 h2 h3 h4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black rook from a8' do
        cell = :a8
        rook = board[cell].piece
        result = rook.create_moves(board).sort
        expected_result = %i[a7 a6 a5 a4 b8 c8 d8].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the classified moves of white rook h1' do
        cell = :h1
        rook = board[cell].piece
        moves = rook.create_moves(board)
        result = rook.classify_moves(moves, board)
        expected_result = { captures: [], empty: [] }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black rook a8' do
        cell = :a8
        rook = board[cell].piece
        moves = rook.create_moves(board)
        result = rook.classify_moves(moves, board)
        expected_result = { captures: [], empty: [] }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnb1kbn1/2p1ppp1/1p6/pPP2r1p/P2pPQ2/3R2qP/3P1PP1/1NB1KBNR b Kq - 4 11'
      end

      it 'returns all the classified moves of white rook e3' do
        cell = :e3
        rook = board[cell].piece
        moves = rook.create_moves(board)
        result = rook.classify_moves(moves, board)
        expected_result = { captures: %i[b3 e4], empty: %i[f3 g3 h3 d3 c3] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black rook c5' do
        cell = :c5
        rook = board[cell].piece
        moves = rook.create_moves(board)
        result = rook.classify_moves(moves, board)
        expected_result = { captures: %i[f5 c4], empty: %i[d5 e5 b5 c6] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
