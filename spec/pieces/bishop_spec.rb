#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'
require_relative '../../lib/components/creators/board-creator'
require_relative '../../lib/board/fen'

describe Bishop do
  let(:fen_processor) { Fen.new }
  let(:board_creator) { BoardCreator.new }
  subject(:bishop) { described_class.new }

  describe '#create_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns all the valid moves of white bishop' do
        bishop.current_cell = :c1
        result = bishop.create_moves(board).sort
        expected_result = %i[b2 d2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black bishop' do
        bishop.current_cell = :f8
        result = bishop.create_moves(board).sort
        expected_result = %i[e7 g7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'r1b1kbnr/ppp2ppp/6p1/3p1B2/3Pq3/4P1Pn/PPPP3P/RNBQK1NR w KQkq - 0 1' }

      it 'returns all the valid moves of white bishop' do
        bishop.current_cell = :f5
        result = bishop.create_moves(board).sort
        expected_result = %i[c8 d7 e6 g4 h3 e4 g6].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black bishop' do
        bishop.current_cell = :c8
        result = bishop.create_moves(board).sort
        expected_result = %i[d7 e6 f5 b7].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns the classified moves of white bishop' do
        bishop.color = 'white'
        bishop.current_cell = :c1
        result = bishop.classify_moves(bishop.create_moves(board), board)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black bishop' do
        bishop.color = 'black'
        bishop.current_cell = :f8
        result = bishop.classify_moves(bishop.create_moves(board), board)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'r1b1kbnr/ppp2ppp/6p1/3p1B2/3Pq3/4P1Pn/PPPP3P/RNBQK1NR w KQkq - 0 1' }

      it 'returns the classified moves of white bishop' do
        bishop.color = 'white'
        bishop.current_cell = :f5
        result = bishop.classify_moves(bishop.create_moves(board), board)
        expected_result = { captures: %i[c8 e4 g6 h3], empty: %i[d7 e6 g4] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black bishop' do
        bishop.color = 'black'
        bishop.current_cell = :c8
        result = bishop.classify_moves(bishop.create_moves(board), board)
        expected_result = { captures: [:f5], empty: %i[d7 e6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#unicode' do
    context 'when the color is white' do
      it 'returns correct unicode' do
        bishop.color = 'white'
        result = bishop.unicode
        expect(result).to eq("\u2657")
      end
    end

    context 'when the color is black' do
      it 'returns correct unicode' do
        bishop.color = 'black'
        result = bishop.unicode
        expect(result).to eq("\u265D")
      end
    end
  end
end
