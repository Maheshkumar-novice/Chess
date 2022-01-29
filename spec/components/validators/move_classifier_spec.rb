#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/components/validators/check-finder'
require_relative '../../../lib/components/creators/board-creator'
require_relative '../../../lib/board/fen'

describe MoveClassifier do
  subject(:move_classifier) { described_class.new }
  let(:fen_processor) { Fen.new }
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
    let(:fen) { 'rnb1K1r1/p1pppp1p/2qQ1Pp1/1b1p2n1/1PP5/7N/P3PPPP/R1NBkB1R w - - 0 1' }
    let(:board) { board_creator.create_board(fen_processor.pieces) }

    it 'classifies white pawn moves' do
      cell = :c4
      color = 'white'
      moves = %i[c5 b5 d5]
      result = move_classifier.classify_pawn_moves(moves, board, cell, color)
      expected_result = { captures: %i[b5 d5], empty: [:c5] }
      result.each { |k, v| result[k] = v.sort }
      expected_result.each { |k, v| expected_result[k] = v.sort }
      expect(result).to eq(expected_result)
    end

    it 'classifies black pawn moves' do
      cell = :e7
      color = 'black'
      moves = %i[e6 e5 d6 f6]
      result = move_classifier.classify_pawn_moves(moves, board, cell, color)
      expected_result = { captures: %i[d6 f6], empty: %i[e6 e5] }
      result.each { |k, v| result[k] = v.sort }
      expected_result.each { |k, v| expected_result[k] = v.sort }
      expect(result).to eq(expected_result)
    end
  end
end
