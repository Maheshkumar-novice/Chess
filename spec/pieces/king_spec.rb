#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/components/creators/board-creator'
require_relative '../../lib/board/fen'

describe King do
  let(:fen_processor) { Fen.new }
  let(:board_creator) { BoardCreator.new }
  subject(:king) { described_class.new }

  describe '#create_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns all the valid moves of white king' do
        king.current_cell = :e1
        result = king.create_moves(board).sort
        expected_result = %i[d1 f1 d2 e2 f2].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black king' do
        king.current_cell = :e8
        result = king.create_moves(board).sort
        expected_result = %i[d8 f8 d7 e7 f7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { '7r/1b1q1n2/1ppn1p1b/2Pppkpp/pPNQ1P2/RP1PP1PP/1N1B2K1/2B1Rr2 w - - 0 1' }

      it 'returns all the valid moves of white king' do
        king.current_cell = :g2
        result = king.create_moves(board).sort
        expected_result = %i[h2 h1 g1 f1 f2 f3 g3 h3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black king' do
        king.current_cell = :f5
        result = king.create_moves(board).sort
        expected_result = %i[e6 f6 g6 e5 g5 e4 f4 g4].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns the classified moves of white king' do
        king.color = 'white'
        king.current_cell = :e1
        result = king.classify_moves(king.create_moves(board), board)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black king' do
        king.color = 'black'
        king.current_cell = :e8
        result = king.classify_moves(king.create_moves(board), board)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { '7r/1b1q1n2/1ppn1p1b/2Pppkpp/pPNQ1P2/RP1PP1PP/1N1B2K1/2B1Rr2 w - - 0 1' }

      it 'returns the classified moves of white king' do
        king.color = 'white'
        king.current_cell = :g2
        result = king.classify_moves(king.create_moves(board), board)
        expected_result = { captures: %i[f1], empty: %i[h2 f2 f3 g1 h1] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black king' do
        king.color = 'black'
        king.current_cell = :f5
        result = king.classify_moves(king.create_moves(board), board)
        expected_result = { captures: %i[f4], empty: %i[e6 g6 e4 g4] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#in_check?' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with white king not in check' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns false' do
        king.current_cell = :e1
        result = king.in_check?(board)
        expect(result).to eq(false)
      end
    end

    context 'with white king in check' do
      let(:fen) { 'r1bqkbnr/pp1ppppp/n1p5/8/1K6/3PP3/PPP2PPP/RNBQ1BNR w kq - 0 1' }

      it 'returns true' do
        king.current_cell = :e1
        result = king.in_check?(board)
        expect(result).to eq(true)
      end
    end

    context 'with black king not in check' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns false' do
        king.current_cell = :e1
        result = king.in_check?(board)
        expect(result).to eq(false)
      end
    end

    context 'with black king in check' do
      let(:fen) { 'r1bq1bnr/pp1pkppp/n1p1p3/6B1/4P3/2KP4/PPP2PPP/RN1Q1BNR w - - 0 1' }

      it 'returns true' do
        king.current_cell = :e1
        result = king.in_check?(board)
        expect(result).to eq(true)
      end
    end
  end

  describe '#unicode' do
    context 'when the color is white' do
      it 'returns correct unicode' do
        king.color = 'white'
        result = king.unicode
        expect(result).to eq("\u2654")
      end
    end

    context 'when the color is black' do
      it 'returns correct unicode' do
        king.color = 'black'
        result = king.unicode
        expect(result).to eq("\u265A")
      end
    end
  end
end
