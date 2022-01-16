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

      it 'returns all the moves of white king from d3' do
        cell = :d3
        king = board[cell].piece
        result = king.create_moves(board).sort
        expected_result = %i[c4 d4 e4 e3 c3 c2 d2 e2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black king from d5' do
        cell = :d5
        king = board[cell].piece
        result = king.create_moves(board).sort
        expected_result = %i[c6 d6 e6 c5 e5 c4 d4 e4].sort
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

      it 'returns all the classified moves of white king d2' do
        cell = :d2
        king = board[cell].piece
        moves = king.create_moves(board)
        result = king.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[c2 c1 d1 e1 e3] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black king d7' do
        cell = :d7
        king = board[cell].piece
        moves = king.create_moves(board)
        result = king.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[c8 d8 e8 d6] }
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

    context 'when e1 in check by  b4' do
      let(:fen) { 'rnbqk1nr/pppp3p/4pp2/5Pp1/1b6/3P4/PPP1P1PP/RNBQKBNR w KQkq - 0 1' }

      it 'returns true' do
        result = board[:e1].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when e8 in check by e6' do
      let(:fen) { 'rnb1k1nr/pppp3p/4Qp2/3pPPp1/1b6/3P1q2/PPP3PP/RNB1KBNR w KQkq - 0 1' }

      it 'returns true' do
        result = board[:e8].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when e1 in check by e3' do
      let(:fen) { 'rnb1k1nr/pppp3p/3Q1p2/2bpPPp1/6B1/3Pq3/PPP3PP/RNB1K1NR w KQkq - 0 1' }

      it 'returns true' do
        result = board[:e1].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when e1 in check by d2' do
      let(:fen) { 'rnb1k1nr/pppp3p/3Q1p2/2b1PPp1/5qB1/3P4/PPPp2PP/RNB1K1NR w KQkq - 0 1' }

      it 'returns true' do
        result = board[:e1].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when d2 in check by f2' do
      let(:fen) { 'rnb1k1n1/pppp3p/3Q1p2/2b1PPp1/3p2B1/3P4/PPPK1rPP/RNB3NR w q - 0 1' }

      it 'returns true' do
        result = board[:d2].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when e8 in check by b7' do
      let(:fen) { 'rnb1k1n1/pppp2Np/3Q1p2/2b1PPp1/3p2B1/3P2r1/PPPK2PP/R1B3NR w q - 0 1' }

      it 'returns true' do
        result = board[:e8].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when e8 in check by f7' do
      let(:fen) { 'rnb1k1n1/pppp1KNp/3Q1p2/2b1PPp1/3p2B1/3P2r1/PPP3PP/R1B3NR w q - 0 1' }

      it 'returns true' do
        result = board[:e8].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when f7 in check by e8' do
      let(:fen) { 'rnb1k1n1/pppp1KNp/3Q1p2/2b1PPp1/3p2B1/3P2r1/PPP3PP/R1B3NR w q - 0 1' }

      it 'returns true' do
        result = board[:f7].piece.in_check?(board)
        expect(result).to eq true
      end
    end

    context 'when e8 not in check' do
      let(:fen) { 'rnb1k1nr/pppp3p/3Q1p2/3pPPp1/1b4B1/3P1q2/PPP3PP/RNB1K1NR w KQkq - 0 1' }

      it 'returns false' do
        result = board[:e8].piece.in_check?(board)
        expect(result).to eq false
      end
    end

    context 'when a1 not in check' do
      let(:fen) { 'rnb1k1nr/pppp3p/3Q1p2/3pPPp1/1b4B1/3P1q2/PPP3PP/KNB2RNR w Kkq - 0 1' }

      it 'returns false' do
        result = board[:a1].piece.in_check?(board)
        expect(result).to eq false
      end
    end

    context 'when e2 not in check' do
      let(:fen) { 'rnb1k1nr/pppp3p/3Q1p2/3pPPp1/qb4B1/3P4/PPP1K1PP/1NB2RNR w kq - 0 1' }

      it 'returns false' do
        result = board[:e2].piece.in_check?(board)
        expect(result).to eq false
      end
    end

    context 'when h6 not in check' do
      let(:fen) { 'rnb3nr/pppp3p/3Q1p1k/3pPPp1/qb4B1/3P4/PPP1K1PP/1NB2RNR w - - 0 1' }

      it 'returns false' do
        result = board[:h6].piece.in_check?(board)
        expect(result).to eq false
      end
    end
  end
end
