#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/fen'

describe Pawn do
  let(:fen) { Fen.new }
  let(:default_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

  before do
    fen.process(fen_code)
  end

  describe 'Board#create_moves' do
    context 'with default fen board' do
      let(:fen_code) { default_fen }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

      it 'returns all the moves of white pawn from a2' do
        cell = :a2
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[a3 a4 b3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black pawn from a7' do
        cell = :a7
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[a6 a5 b6].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:fen_code) { 'rnb1kbnr/ppp2ppp/3ppq2/8/8/BPN5/P1PPPPPP/R2QKBNR w KQkq - 0 4' }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

      it 'returns all the moves of black pawn from d6' do
        cell = :d6
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[d5 c5 e5].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from b3' do
        cell = :b3
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[a4 b4 c4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black pawn from f7' do
        cell = :f7
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[e6 f6 g6].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from c2' do
        cell = :c2
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[b3 c3 d3].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:fen_code) { default_fen }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

      it 'returns all the classified moves of white pawn f2' do
        cell = :f2
        pawn = board[cell].piece
        moves = pawn.create_moves(board)
        result = pawn.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[f3 f4] }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black pawn c7' do
        cell = :c7
        pawn = board[cell].piece
        moves = pawn.create_moves(board)
        result = pawn.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[c6 c5] }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:fen_code) { 'rnb1kbnr/2p1pppp/1p1q4/p1Pp4/PP6/8/3PPPPP/RNBQKBNR w KQkq a6 0 5' }
      let(:board) { Board.new(fen.pieces, fen.meta_data).board }

      it 'returns all the classified moves of white pawn b4' do
        cell = :b4
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: %i[a5], empty: %i[b5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black pawn b6' do
        cell = :b6
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: %i[c5], empty: %i[b5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end
end
