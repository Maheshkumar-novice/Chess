#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe 'Pawn' do
  describe 'Board#create_moves' do
    subject(:board) { Board.new }

    context 'with default fen board' do
      it 'returns all the moves of white pawn from a2' do
        cell = :a2
        result = board.create_moves(cell).sort
        expected_result = %i[a3 a4 b3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from a3' do
        chess_board = board.instance_variable_get(:@board)
        prev_a2_piece = chess_board[:a2].piece
        chess_board[:a2].piece = nil
        chess_board[:a3].piece = prev_a2_piece
        board.instance_variable_set(:@board, chess_board)
        cell = :a3
        result = board.create_moves(cell).sort
        expected_result = %i[a4 b4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from d2' do
        cell = :d2
        result = board.create_moves(cell).sort
        expected_result = %i[d3 d4 c3 e3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black pawn from a7' do
        cell = :a7
        result = board.create_moves(cell).sort
        expected_result = %i[a6 a5 b6].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from a6' do
        chess_board = board.instance_variable_get(:@board)
        prev_a7_piece = chess_board[:a7].piece
        chess_board[:a7].piece = nil
        chess_board[:a6].piece = prev_a7_piece
        board.instance_variable_set(:@board, chess_board)
        cell = :a6
        result = board.create_moves(cell).sort
        expected_result = %i[a5 b5].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from d7' do
        cell = :d7
        result = board.create_moves(cell).sort
        expected_result = %i[c6 d6 e6 d5].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of pawn from f3' do
        chess_board = board.instance_variable_get(:@board)
        prev_f2_piece = chess_board[:f2].piece
        chess_board[:f2].piece = nil
        chess_board[:f3].piece = prev_f2_piece
        board.instance_variable_set(:@board, chess_board)
        cell = :f3
        result = board.create_moves(cell).sort
        expected_result = %i[g4 f4 e4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns no moves of white pawn when at the first row of black' do
        chess_board = board.instance_variable_get(:@board)
        prev_a2_piece = chess_board[:a2].piece
        chess_board[:a8].piece = prev_a2_piece
        chess_board[:a7].piece = nil
        board.instance_variable_set(:@board, chess_board)
        cell = :a8
        result = board.create_moves(cell)
        expected_result = []
        expect(result).to eq(expected_result)
      end

      it 'returns no moves of black pawn when at the first row of white' do
        chess_board = board.instance_variable_get(:@board)
        prev_a7_piece = chess_board[:a7].piece
        chess_board[:a1].piece = prev_a7_piece
        chess_board[:a2].piece = nil
        board.instance_variable_set(:@board, chess_board)
        cell = :a1
        result = board.create_moves(cell)
        expected_result = []
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnb1kbnr/ppp2ppp/3ppq2/8/8/BPN5/P1PPPPPP/R2QKBNR w KQkq - 0 4'
      end

      it 'returns all the moves of white pawn from e3' do
        cell = :e3
        result = board.create_moves(cell).sort
        expected_result = %i[e4 d4 f4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black pawn from b6' do
        cell = :b6
        result = board.create_moves(cell).sort
        expected_result = %i[a5 b5 c5].sort
        expect(result).to eq(expected_result)
      end
    end
  end
end
