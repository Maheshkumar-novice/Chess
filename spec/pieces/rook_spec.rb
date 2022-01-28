#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative '../../lib/components/creators/board-creator'
require_relative '../../lib/board/fen'

describe Rook do
  let(:fen_processor) { Fen.new }
  let(:board_creator) { BoardCreator.new }
  subject(:rook) { described_class.new }

  describe '#create_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns all the valid moves of white rook' do
        rook.current_cell = :a1
        result = rook.create_moves(board).sort
        expected_result = %i[a2 b1].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black rook' do
        rook.current_cell = :h8
        result = rook.create_moves(board).sort
        expected_result = %i[g8 h7].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'r1b1kbn1/ppp2pp1/1Q2n1p1/3pR2p/1r1PqB2/2P1P1P1/PP1P3P/RNB1K1N1 w Qq - 0 1' }

      it 'returns all the valid moves of white rook' do
        rook.current_cell = :e5
        result = rook.create_moves(board).sort
        expected_result = %i[d5 e6 e4 f5 g5 h5].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black rook' do
        rook.current_cell = :b4
        result = rook.create_moves(board).sort
        expected_result = %i[a4 c4 d4 b5 b6 b3 b2].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns the classified moves of white rook' do
        rook.color = 'white'
        rook.current_cell = :h1
        result = rook.classify_moves(rook.create_moves(board), board)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black rook' do
        rook.color = 'black'
        rook.current_cell = :a8
        result = rook.classify_moves(rook.create_moves(board), board)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'r1b1kbn1/ppp2pp1/1Q2n1p1/3pR2p/1r1PqB2/2P1P1P1/PP1P3P/RNB1K1N1 w Qq - 0 1' }

      it 'returns the classified moves of white rook' do
        rook.color = 'white'
        rook.current_cell = :e5
        result = rook.classify_moves(rook.create_moves(board), board)
        expected_result = { captures: %i[d5 e6 e4 h5], empty: %i[f5 g5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black rook' do
        rook.color = 'black'
        rook.current_cell = :b4
        result = rook.classify_moves(rook.create_moves(board), board)
        expected_result = { captures: %i[b6 b2 d4], empty: %i[a4 c4 b5 b3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#unicode' do
    context 'when the color is white' do
      it 'returns correct unicode' do
        rook.color = 'white'
        result = rook.unicode
        expect(result).to eq("\u2656")
      end
    end

    context 'when the color is black' do
      it 'returns correct unicode' do
        rook.color = 'black'
        result = rook.unicode
        expect(result).to eq("\u265C")
      end
    end
  end
end
