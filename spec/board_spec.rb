#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#make_move' do
    context 'with default fen board' do
      context 'when a2 moves to a4' do
        it 'moves a2 to a4' do
          chess_board = board.board
          source = :a2
          destination = :a4
          previous_source_piece = chess_board[:a2].piece
          board.make_move(source, destination)
          expect(chess_board[:a2].piece).to be_nil
          expect(chess_board[:a4].piece).to eq(previous_source_piece)
        end
      end

      context 'when g1 moves to f3' do
        it 'moves g1 to f3' do
          chess_board = board.board
          source = :g1
          destination = :f3
          previous_source_piece = chess_board[:g1].piece
          board.make_move(source, destination)
          expect(chess_board[:g1].piece).to be_nil
          expect(chess_board[:f3].piece).to eq(previous_source_piece)
        end
      end
    end

    context 'with custom fen board' do
      subject(:board) { described_class.new(fen) }
      let(:fen) do
        'rnb1kbnr/ppp2ppp/3ppq2/8/8/BPN5/P1PPPPPP/R2QKBNR w KQkq - 0 4'
      end

      context 'when f3 moves to e5' do
        it 'moves f3 to e5' do
          chess_board = board.board
          source = :f3
          destination = :e5
          previous_source_piece = chess_board[:f3].piece
          board.make_move(source, destination)
          expect(chess_board[:f3].piece).to be_nil
          expect(chess_board[:e5].piece).to eq(previous_source_piece)
        end
      end

      context 'when c6 moves to c3' do
        it 'moves c6 to c3' do
          chess_board = board.board
          source = :c6
          destination = :c3
          previous_source_piece = chess_board[:c6].piece
          board.make_move(source, destination)
          expect(chess_board[:c6].piece).to be_nil
          expect(chess_board[:c3].piece).to eq(previous_source_piece)
        end
      end
    end
  end

  describe '#moves_from_source' do
    context 'with default fen board' do
      it 'returns all valid moves of g1' do
        cell = :g1
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[h3 f3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of a7' do
        cell = :a7
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[a6 a5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of e8' do
        cell = :e8
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom fen board' do
      subject(:board) { described_class.new(fen) }
      let(:fen) { 'rnb2b2/pp1N1Ppp/1R1kpn2/B1p1N1q1/1QPP1p1r/P2Kp1B1/PP1P3P/3R4 w - - 0 1' }

      it 'returns all valid moves of b3' do
        cell = :b3
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: %i[a4 c4], empty: %i[c2 d1] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of e6' do
        cell = :e6
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[d7 f7] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of e7' do
        cell = :e7
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: %i[g8 c6 c8 f5], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of f5' do
        cell = :f5
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of g8' do
        cell = :g8
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [:f6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of f8' do
        cell = :f8
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of g2' do
        cell = :g2
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [:g3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of b5' do
        cell = :b5
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of g4' do
        cell = :g4
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [:f5], empty: %i[g5 g3 h4 f3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all valid moves of e2' do
        cell = :e2
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [:d3], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end
end
