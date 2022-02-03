#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'
require_relative '../../lib/components/creators/board-creator'
require_relative '../../lib/board/fen-processor'

describe Pawn do
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  subject(:pawn) { described_class.new }

  describe '#create_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns all the valid moves of white pawn' do
        pawn.current_cell = :d2
        pawn.color = 'white'
        result = pawn.create_moves(board).sort
        expected_result = %i[d3 d4 c3 e3].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black pawn' do
        pawn.current_cell = :f7
        pawn.color = 'black'
        result = pawn.create_moves(board).sort
        expected_result = %i[f6 f5 e6 g6].sort
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'rnbqkbnr/pp1p1ppp/8/2p5/3Pp3/5P2/PPP1P1PP/RNBQKBNR w KQkq - 0 1' }

      it 'returns all the valid moves of white pawn' do
        pawn.current_cell = :d4
        pawn.color = 'white'
        result = pawn.create_moves(board).sort
        expected_result = %i[d5 c5 e5].sort
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black pawn' do
        pawn.current_cell = :e4
        pawn.color = 'black'
        result = pawn.create_moves(board).sort
        expected_result = %i[e3 d3 f3].sort
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#classify_moves' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    before { fen_processor.process(fen) }

    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns the classified moves of white pawn' do
        pawn.color = 'white'
        pawn.current_cell = :e2
        result = pawn.classify_moves(pawn.create_moves(board), board)
        expected_result = { captures: [], empty: %i[e3 e4] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black pawn' do
        pawn.color = 'black'
        pawn.current_cell = :a7
        result = pawn.classify_moves(pawn.create_moves(board), board)
        expected_result = { captures: [], empty: %i[a6 a5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'rnbqkbnr/pp1p1ppp/8/2p5/3Pp3/5P2/PPP1P1PP/RNBQKBNR w KQkq - 0 1' }

      it 'returns the classified moves of white pawn' do
        pawn.color = 'white'
        pawn.current_cell = :d4
        result = pawn.classify_moves(pawn.create_moves(board), board)
        expected_result = { captures: %i[c5], empty: %i[d5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns the classified moves of black pawn' do
        pawn.color = 'black'
        pawn.current_cell = :e4
        result = pawn.classify_moves(pawn.create_moves(board), board)
        expected_result = { captures: %i[f3], empty: %i[e3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#unicode' do
    context 'when the color is white' do
      it 'returns correct unicode' do
        pawn.color = 'white'
        result = pawn.unicode
        expect(result).to eq("\u2659")
      end
    end

    context 'when the color is black' do
      it 'returns correct unicode' do
        pawn.color = 'black'
        result = pawn.unicode
        expect(result).to eq("\u265F")
      end
    end
  end
end
