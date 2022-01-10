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

      it 'returns all the moves of black pawn from e6' do
        cell = :e6
        result = board.create_moves(cell).sort
        expected_result = %i[d5 f5 e5].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from g3' do
        cell = :g3
        result = board.create_moves(cell).sort
        expected_result = %i[f4 g4 h4].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of black pawn from c7' do
        cell = :c7
        result = board.create_moves(cell).sort
        expected_result = %i[c6 b6 d6].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the moves of white pawn from f2' do
        cell = :f2
        result = board.create_moves(cell).sort
        expected_result = %i[f3 e3 g3].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe 'Board#classify_moves' do
    subject(:board) { Board.new }
    let(:result) { board.classify_moves(cell, board.create_moves(cell)) }

    context 'with default fen board' do
      context 'when moves of white pawn f2 are classified' do
        let(:cell) { :f2 }

        it 'returns all the empty moves' do
          empty = result[:empty]
          expected_result = %i[f3 f4]
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures]
          expected_result = []
          expect(captures).to eq(expected_result)
        end
      end

      context 'when moves of black pawn c7 are classified' do
        let(:cell) { :c7 }

        it 'returns all the empty moves' do
          empty = result[:empty]
          expected_result = %i[c6 c5]
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures]
          expected_result = []
          expect(captures).to eq(expected_result)
        end
      end
    end

    context 'with cusom fen board' do
      subject(:board) { Board.new(fen) }
      let(:fen) do
        'rnb1kbnr/2p1pppp/1p1q4/p1Pp4/PP6/8/3PPPPP/RNBQKBNR w KQkq a6 0 5'
      end

      context 'when moves of white pawn g4 are classified' do
        let(:cell) { :g4 }

        it 'returns all the empty moves' do
          empty = result[:empty]
          expected_result = %i[g5]
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures]
          expected_result = [:h5]
          expect(captures).to eq(expected_result)
        end
      end

      context 'when moves of black pawn g6 are classified' do
        let(:cell) { :g6 }

        it 'returns all the empty moves' do
          empty = result[:empty]
          expected_result = [:g5]
          expect(empty).to eq(expected_result)
        end

        it 'returns all the captures' do
          captures = result[:captures]
          expected_result = [:f5]
          expect(captures).to eq(expected_result)
        end
      end
    end
  end
end
