#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board'

describe Knight do
  describe '#create_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the moves of white knight from b1' do
        cell = :b1
        knight = board[cell].piece
        result = knight.create_moves(board).sort
        expected_result = %i[a3 c3 d2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black knight from g8' do
        cell = :g8
        knight = board[cell].piece
        result = knight.create_moves(board).sort
        expected_result = %i[h6 f6 e7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'rnbqk2r/ppppppb1/5n2/6p1/P6p/3PP2P/1PPNBPPR/R1BQK1N1 b Qkq - 2 7'
      end

      it 'returns all the moves of white knight from e2' do
        cell = :e2
        knight = board[cell].piece
        result = knight.create_moves(board).sort
        expected_result = %i[d4 f4 c3 c1 g3 g1].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black knight from c6' do
        cell = :c6
        knight = board[cell].piece
        result = knight.create_moves(board).sort
        expected_result = %i[b4 d4 e5 e7 d8 b8 a5 a7].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    context 'with default fen board' do
      let(:board) { Board.new.board }

      it 'returns all the classified moves of white knight b1' do
        cell = :b1
        knight = board[cell].piece
        moves = knight.create_moves(board)
        result = knight.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[a3 c3] }
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black knight g8' do
        cell = :g8
        knight = board[cell].piece
        moves = knight.create_moves(board)
        result = knight.classify_moves(moves, board)
        expected_result = { captures: [], empty: %i[h6 f6] }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      let(:board) { Board.new(fen).board }
      let(:fen) do
        'r1k2bnr/p1p2ppp/1p2p1N1/2Bpqb2/1n1P4/1PPQ4/P3PPPP/RN2KB1R b KQ - 7 12'
      end

      it 'returns all the classified moves of white knight b6' do
        cell = :b6
        knight = board[cell].piece
        moves = knight.create_moves(board)
        result = knight.classify_moves(moves, board)
        expected_result = { captures: %i[a8 c8 d5], empty: %i[d7 c4 a4] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the classified moves of black knight g4' do
        cell = :g4
        knight = board[cell].piece
        moves = knight.create_moves(board)
        result = knight.classify_moves(moves, board)
        expected_result = { captures: %i[h2 e3], empty: %i[f6 h6 f2] }
        result[:empty] = result[:empty].sort
        result[:captures] = result[:captures].sort
        expected_result[:empty] = expected_result[:empty].sort
        expected_result[:captures] = expected_result[:captures].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
