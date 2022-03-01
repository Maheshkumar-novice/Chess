#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/pieces/knight'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe Knight do
  subject(:knight) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }

  describe '#create_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns all the valid moves of white knight' do
        knight.current_cell = :b1
        result = knight.create_moves(board).sort
        expected_result = %i[a3 c3 d2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black knight' do
        knight.current_cell = :g8
        result = knight.create_moves(board).sort
        expected_result = %i[h6 f6 e7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'rnb1kb1r/pppR2pp/4p3/1BpNnqB1/1P1P4/2Q1P1p1/P1P1P1PP/R3K1N1 w Qkq - 0 1' }

      it 'returns all the valid moves of white knight' do
        knight.current_cell = :d5
        result = knight.create_moves(board).sort
        expected_result = %i[c7 e7 f6 f4 e3 c3 b4 b6].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black knight' do
        knight.current_cell = :e5
        result = knight.create_moves(board).sort
        expected_result = %i[d7 f7 g6 g4 d3 f3 c4 c6].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns the classified moves of white knight' do
        knight.color = 'white'
        knight.current_cell = :g1
        result = knight.classify_moves(knight.create_moves(board), board)
        expected_result = { captures: [], empty: %i[f3 h3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black knight' do
        knight.color = 'black'
        knight.current_cell = :b8
        result = knight.classify_moves(knight.create_moves(board), board)
        expected_result = { captures: [], empty: %i[c6 a6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'rnb1kb1r/pppR2pp/4p3/1BpNnqB1/1P1P4/2Q1P1p1/P1P1P1PP/R3K1N1 w Qkq - 0 1' }

      it 'returns the classified moves of white knight' do
        knight.color = 'white'
        knight.current_cell = :d5
        result = knight.classify_moves(knight.create_moves(board), board)
        expected_result = { captures: %i[c7], empty: %i[e7 f6 f4 b6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black knight' do
        knight.color = 'black'
        knight.current_cell = :e5
        result = knight.classify_moves(knight.create_moves(board), board)
        expected_result = { captures: %i[d7], empty: %i[f7 g6 g4 d3 f3 c4 c6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#unicode' do
    context 'when the color is white' do
      it 'returns correct unicode' do
        knight.color = 'white'
        result = knight.unicode
        expect(result).to eq("\u2658")
      end
    end

    context 'when the color is black' do
      it 'returns correct unicode' do
        knight.color = 'black'
        result = knight.unicode
        expect(result).to eq("\u265E")
      end
    end
  end
end
