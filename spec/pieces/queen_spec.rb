#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/pieces/queen'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe Queen do
  subject(:queen) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }

  describe '#create_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns all the valid moves of white queen' do
        queen.current_cell = :d1
        result = queen.create_moves(board).sort
        expected_result = %i[c1 e1 c2 d2 e2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black queen' do
        queen.current_cell = :d8
        result = queen.create_moves(board).sort
        expected_result = %i[c8 e8 c7 d7 e7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'rn2kbnr/1p3ppp/2pp1p2/pP1q1N2/4b2P/RB1Q1PP1/P2P4/1N1K1B1R w Kkq - 0 1' }

      it 'returns all the valid moves of white queen' do
        queen.current_cell = :d3
        result = queen.create_moves(board).sort
        expected_result = %i[c3 b3 e3 f3 d4 d5 d2 c4 b5 e4 e2 f1 c2 b1].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black queen' do
        queen.current_cell = :d5
        result = queen.create_moves(board).sort
        expected_result = %i[c5 b5 e5 f5 d6 d4 d3 c6 e6 f7 c4 b3 e4].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns the classified moves of white queen' do
        queen.color = 'white'
        queen.current_cell = :d1
        result = queen.classify_moves(queen.create_moves(board), board)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black queen' do
        queen.color = 'black'
        queen.current_cell = :d8
        result = queen.classify_moves(queen.create_moves(board), board)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'rn2kbnr/1p3ppp/2pp1p2/pP1q1N2/4b2P/RB1Q1PP1/P2P4/1N1K1B1R w Kkq - 0 1' }

      it 'returns the classified moves of white queen' do
        queen.color = 'white'
        queen.current_cell = :d3
        result = queen.classify_moves(queen.create_moves(board), board)
        expected_result = { captures: %i[d5 e4], empty: %i[c3 e3 d4 c4 c2 e2] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black queen' do
        queen.color = 'black'
        queen.current_cell = :d5
        result = queen.classify_moves(queen.create_moves(board), board)
        expected_result = { captures: %i[d3 b3 f5 b5], empty: %i[c5 e5 d4 c4 e6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#unicode' do
    context 'when the color is white' do
      it 'returns correct unicode' do
        queen.color = 'white'
        result = queen.unicode
        expect(result).to eq("\u2655")
      end
    end

    context 'when the color is black' do
      it 'returns correct unicode' do
        queen.color = 'black'
        result = queen.unicode
        expect(result).to eq("\u265B")
      end
    end
  end
end
