#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'

describe King do
  describe '#create_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the moves of white king from d1' do
        cell = :d1
        king = board[cell].piece
        result = king.create_moves(board).sort
        expected_result = %i[e1 c1 c2 d2 e2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black king from d8' do
        cell = :d8
        king = board[cell].piece
        result = king.create_moves(board).sort
        expected_result = %i[c8 e8 c7 d7 e7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnb2bnr/pp1p1ppp/8/3k4/1P1P1P2/2pK4/P1PP2PP/RNB2BNR b - - 1 11'
      end

      it 'returns all the moves of white king from e3' do
        cell = :e3
        king = board[cell].piece
        result = king.create_moves(board).sort
        expected_result = %i[f3 d3 d2 e2 f2 d4 e4 f4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black king from e5' do
        cell = :e5
        king = board[cell].piece
        result = king.create_moves(board).sort
        expected_result = %i[d6 e6 f6 d5 f5 d4 e4 f4].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the classified moves of white king d1' do
        cell = :d1
        king = board[cell].piece
        moves = king.create_moves(board)
        result = king.classify_moves(moves, board)
        expected_result = { captures: [], empty: [] }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black king d8' do
        cell = :d8
        king = board[cell].piece
        moves = king.create_moves(board)
        result = king.classify_moves(moves, board)
        expected_result = { captures: [], empty: [] }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'r5nr/p1pkbpp1/2n1p1Np/1pBpQb2/3P4/NPPR1q1P/P2KPPP1/5B1R b - - 4 19'
      end

      it 'returns all the classified moves of white king e2' do
        cell = :e2
        king = board[cell].piece
        moves = king.create_moves(board)
        result = king.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[d1 e1 f1 f2 d3] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black king e7' do
        cell = :e7
        king = board[cell].piece
        moves = king.create_moves(board)
        result = king.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[d8 e8 f8 e6] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#in_check?' do
    let(:board) { Board.new(fen).board }

    context 'when d1 in check by  g4' do
      let(:fen) { 'rnbqk1nr/pppp3p/4pp2/5Pp1/1b6/3P4/PPP1P1PP/RNBQKBNR w KQkq - 0 1' }

      it 'returns true' do
        result = board[:d1].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when d8 in check by d6' do
      let(:fen) { 'rnb1k1nr/pppp3p/4Qp2/3pPPp1/1b6/3P1q2/PPP3PP/RNB1KBNR w KQkq - 0 1' }

      it 'returns true' do
        result = board[:d8].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when d1 in check by d3' do
      let(:fen) { 'rnb1k1nr/pppp3p/3Q1p2/2bpPPp1/6B1/3Pq3/PPP3PP/RNB1K1NR w KQkq - 0 1' }

      it 'returns true' do
        result = board[:d1].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when d1 in check by e2' do
      let(:fen) { 'rnb1k1nr/pppp3p/3Q1p2/2b1PPp1/5qB1/3P4/PPPp2PP/RNB1K1NR w KQkq - 0 1' }

      it 'returns true' do
        result = board[:d1].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when e2 in check by c2' do
      let(:fen) { 'rnb1k1n1/pppp3p/3Q1p2/2b1PPp1/3p2B1/3P4/PPPK1rPP/RNB3NR w q - 0 1' }

      it 'returns true' do
        result = board[:e2].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when d8 in check by g7' do
      let(:fen) { 'rnb1k1n1/pppp2Np/3Q1p2/2b1PPp1/3p2B1/3P2r1/PPPK2PP/R1B3NR w q - 0 1' }

      it 'returns true' do
        result = board[:d8].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when d8 in check by c7' do
      let(:fen) { 'rnb1k1n1/pppp1KNp/3Q1p2/2b1PPp1/3p2B1/3P2r1/PPP3PP/R1B3NR w q - 0 1' }

      it 'returns true' do
        result = board[:d8].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when c7 in check by d8' do
      let(:fen) { 'rnb1k1n1/pppp1KNp/3Q1p2/2b1PPp1/3p2B1/3P2r1/PPP3PP/R1B3NR w q - 0 1' }

      it 'returns true' do
        result = board[:c7].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when d8 not in check' do
      let(:fen) { 'rnb1k1nr/pppp3p/3Q1p2/3pPPp1/1b4B1/3P1q2/PPP3PP/RNB1K1NR w KQkq - 0 1' }

      it 'returns false' do
        result = board[:d8].piece.in_check?(board)
        expect(result).to eq false
      end
    end
  end
end
