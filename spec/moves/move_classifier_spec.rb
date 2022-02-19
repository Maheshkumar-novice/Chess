#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/moves/move-classifier'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe MoveClassifier do
  subject(:move_classifier) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  before { fen_processor.process(fen) }

  describe '#classify_moves' do
    let(:fen) { 'rnb1K1r1/p1pp1p1p/2q1p1p1/1b1p2n1/1P3P2/2P4N/P2QPPPP/R1NBkB1R w - - 0 1' }
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    it 'classifies white moves' do
      color = 'white'
      moves = %i[b7 c7 d7 b6 c6 d6 b5 c5 d5]
      result = move_classifier.classify_moves(color, moves, board)
      expected_result = { captures: %i[c7 d7 c6 b5 d5], empty: %i[b7 b6 d6 c5] }
      result.each { |k, v| result[k] = v.sort }
      expected_result.each { |k, v| expected_result[k] = v.sort }
      expect(result).to eq(expected_result)
    end

    it 'classifies black moves' do
      color = 'black'
      moves = %i[e1 f1 g1 e2 f2 g2 e3 f3 g3]
      result = move_classifier.classify_moves(color, moves, board)
      expected_result = { captures: %i[f1 e2 f2 g2], empty: %i[e3 f3 g3 g1] }
      result.each { |k, v| result[k] = v.sort }
      expected_result.each { |k, v| expected_result[k] = v.sort }
      expect(result).to eq(expected_result)
    end
  end

  describe '#classify_pawn_moves' do
    context 'for regular moves' do
      let(:fen) { 'rnb1K1r1/p1pppp1p/2qQ1Pp1/1b1p2n1/1PP5/7N/P3PPPP/R1NBkB1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }
      let(:meta_data) { fen_processor.meta_data }

      it 'classifies white pawn moves' do
        cell = :c4
        color = 'white'
        moves = %i[c5 b5 d5]
        result = move_classifier.classify_pawn_moves(moves, board, meta_data, cell, color)
        expected_result = { captures: %i[b5 d5], empty: [:c5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'classifies black pawn moves' do
        cell = :e7
        color = 'black'
        moves = %i[e6 e5 d6 f6]
        result = move_classifier.classify_pawn_moves(moves, board, meta_data, cell, color)
        expected_result = { captures: %i[d6 f6], empty: %i[e6 e5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'for en_passant moves' do
      context 'when black can capture en_passant' do
        let(:fen) { 'rnbqkbnr/p1pppppp/8/P7/1pP5/RP6/3PPPPP/1NBQKBNR b Kkq c3 0 1' }
        let(:board) { board_creator.create_board(fen_processor.pieces) }
        let(:meta_data) { fen_processor.meta_data }

        it 'classifies black pawn moves' do
          cell = :b4
          color = 'black'
          moves = %i[a3 b3 c3]
          result = move_classifier.classify_pawn_moves(moves, board, meta_data, cell, color)
          expected_result = { captures: %i[a3 c3], empty: [] }
          result.each { |k, v| result[k] = v.sort }
          expected_result.each { |k, v| expected_result[k] = v.sort }
          expect(result).to eq(expected_result)
        end
      end

      context 'when white can capture en_passant' do
        let(:fen) { 'rnbqkbnr/p1ppp2p/4Qp2/P4Pp1/1pP5/RP6/3PP1PP/1NB1KBNR w Kkq g6 0 1' }
        let(:board) { board_creator.create_board(fen_processor.pieces) }
        let(:meta_data) { fen_processor.meta_data }

        it 'classifies white pawn moves' do
          cell = :f5
          color = 'white'
          moves = %i[e6 f6 g6]
          result = move_classifier.classify_pawn_moves(moves, board, meta_data, cell, color)
          expected_result = { captures: %i[g6], empty: [] }
          result.each { |k, v| result[k] = v.sort }
          expected_result.each { |k, v| expected_result[k] = v.sort }
          expect(result).to eq(expected_result)
        end
      end
    end
  end
end
