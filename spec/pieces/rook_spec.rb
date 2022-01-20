#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/fen'

describe Rook do
  let(:fen) { Fen.new }
  let(:default_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

  before do
    fen.process(fen_code)
  end

  describe '#create_moves' do
    context 'with default fen board' do
      let(:fen_code) { default_fen }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

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
      let(:fen_code) { 'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7' }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

      it 'returns all the moves of white rook from a1' do
        cell = :a1
        rook = board[cell].piece
        result = rook.create_moves(board).sort
        expected_result = %i[a2 a3 a4 b1 c1].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black rook from h8' do
        cell = :h8
        rook = board[cell].piece
        result = rook.create_moves(board).sort
        expected_result = %i[h7 h6 h5 h4 g8 f8 e8].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:fen_code) { default_fen }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

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
      let(:fen_code) { 'rnb1kbn1/2p1ppp1/1p6/pPP2r1p/P2pPQ2/3R2qP/3P1PP1/1NB1KBNR b Kq - 4 11' }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

      it 'returns all the classified moves of white rook d3' do
        cell = :d3
        rook = board[cell].piece
        moves = rook.create_moves(board)
        result = rook.classify_moves(moves, board)
        expected_result = { captures: %i[g3 d4], empty: %i[a3 b3 c3 e3 f3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black rook f5' do
        cell = :f5
        rook = board[cell].piece
        moves = rook.create_moves(board)
        result = rook.classify_moves(moves, board)
        expected_result = { captures: %i[c5 f4], empty: %i[f6 g5 d5 e5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end
end
