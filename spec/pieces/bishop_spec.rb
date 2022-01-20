#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/fen'

describe Bishop do
  let(:fen) { Fen.new }
  let(:default_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

  before do
    fen.process(fen_code)
  end

  describe '#create_moves' do
    context 'with default fen board' do
      let(:fen_code) { default_fen }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

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
      let(:fen_code) { 'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7' }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

      it 'returns all the moves of white bishop from e2' do
        cell = :e2
        bishop = board[cell].piece
        result = bishop.create_moves(board).sort
        expected_result = %i[d3 f3 g4 h5 d1 f1].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black bishop from g7' do
        cell = :g7
        bishop = board[cell].piece
        result = bishop.create_moves(board).sort
        expected_result = %i[f8 h8 f6 h6].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:fen_code) { default_fen }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

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
      let(:fen_code) { 'rnk2bnr/p1p2ppp/1p1qp1N1/2Bp1b2/3P4/1PP5/P1Q1PPPP/RN2KB1R b KQ - 1 9' }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

      it 'returns all the classified moves of white bishop c5' do
        cell = :c5
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: %i[b6 d6], empty: %i[b4 a3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black bishop f5' do
        cell = :f5
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: %i[g6 c2], empty: %i[g4 h3 e4 d3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end
end
