#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/fen'

describe Board do
  let(:fen) { Fen.new }
  let(:default_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

  before do
    fen.process(fen_code)
  end

  describe '#initialize' do
    let(:fen_code) { default_fen }
    subject(:board) { described_class.new(fen.pieces, fen.meta_data) }

    it 'creates a board of size 64' do
      chess_board = board.board
      result = chess_board.size
      expected_result = 64
      expect(result).to eq(expected_result)
    end

    it 'creates a board whose first cell is a8' do
      first_cell = board.board.first[0]
      result = first_cell
      expected_result = :a8
      expect(result).to eq(expected_result)
    end

    it 'creates a board whose last cell is h1' do
      last_cell = board.board.keys.last
      result = last_cell
      expected_result = :h1
      expect(result).to eq(expected_result)
    end
  end

  describe '#make_move' do
    context 'with default fen board' do
      let(:fen_code) { default_fen }
      subject(:board) { described_class.new(fen.pieces, fen.meta_data) }

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
      let(:fen_code) { 'rnb1kbnr/ppp2ppp/3ppq2/8/8/BPN5/P1PPPPPP/R2QKBNR w KQkq - 0 4' }
      subject(:board) { described_class.new(fen.pieces, fen.meta_data) }

      context 'when c3 moves to d5' do
        it 'moves c3 to d5' do
          chess_board = board.board
          source = :c3
          destination = :d5
          previous_source_piece = chess_board[:c3].piece
          board.make_move(source, destination)
          expect(chess_board[:c3].piece).to be_nil
          expect(chess_board[:d5].piece).to eq(previous_source_piece)
        end
      end

      context 'when f6 moves to f2' do
        it 'moves f6 to f2' do
          chess_board = board.board
          source = :f6
          destination = :f2
          previous_source_piece = chess_board[:f6].piece
          board.make_move(source, destination)
          expect(chess_board[:f6].piece).to be_nil
          expect(chess_board[:f2].piece).to eq(previous_source_piece)
        end
      end
    end
  end

  describe '#moves_from_source' do
    context 'with default fen board' do
      let(:fen_code) { default_fen }
      subject(:board) { described_class.new(fen.pieces, fen.meta_data) }

      it 'returns all the valid moves of g1' do
        cell = :g1
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[h3 f3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of a7' do
        cell = :a7
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[a6 a5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of e8' do
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
      let(:fen_code) { 'rnb2b2/pp1N1Ppp/1R1kpn2/B1p1N1q1/1QPP1p1r/P2Kp1B1/PP1P3P/3R4 w - - 0 1' }
      subject(:board) { described_class.new(fen.pieces, fen.meta_data) }

      it 'returns all the valid moves of g3' do
        cell = :g3
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: %i[f4 h4], empty: %i[f2 e1] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of d6' do
        cell = :d6
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[c7 e7] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of d7' do
        cell = :d7
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: %i[b8 c5 f6 f8], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of c5' do
        cell = :c5
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of b8' do
        cell = :b8
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [:c6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of c8' do
        cell = :c8
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of b2' do
        cell = :b2
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [:b3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of g5' do
        cell = :g5
        color = 'black'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of b4' do
        cell = :b4
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [:c5], empty: %i[a4 b5 b3 c3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of d2' do
        cell = :d2
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [:e3], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of d3' do
        cell = :d3
        color = 'white'
        result = board.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[c3 e2 c2] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end
end
