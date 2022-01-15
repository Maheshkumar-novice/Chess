#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'

describe Pawn do
  describe 'Board#create_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

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
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnb1kbnr/ppp2ppp/3ppq2/8/8/BPN5/P1PPPPPP/R2QKBNR w KQkq - 0 4'
      end

      it 'returns all the moves of black pawn from e6' do
        cell = :e6
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[d5 f5 e5].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from g3' do
        cell = :g3
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[f4 g4 h4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black pawn from c7' do
        cell = :c7
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[c6 b6 d6].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from f2' do
        cell = :f2
        pawn = board[cell].piece
        result = pawn.create_moves(board).sort
        expected_result = %i[f3 e3 g3].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

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
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnb1kbnr/2p1pppp/1p1q4/p1Pp4/PP6/8/3PPPPP/RNBQKBNR w KQkq a6 0 5'
      end

      it 'returns all the classified moves of white pawn g4' do
        cell = :g4
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: %i[h5], empty: %i[g5] }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black pawn g6' do
        cell = :g6
        bishop = board[cell].piece
        moves = bishop.create_moves(board)
        result = bishop.classify_moves(moves, board)
        expected_result = { captures: %i[f5], empty: %i[g5] }
        expect(result).to eq(expected_result)
      end
    end
  end
end
