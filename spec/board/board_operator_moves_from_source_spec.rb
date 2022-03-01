#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board/board-operator'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe BoardOperator do
  subject(:board_operator) { described_class.new(board, meta_data) }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  let(:board) { board_creator.create_board(fen_processor.pieces) }
  let(:meta_data) { fen_processor.meta_data }
  before { fen_processor.process(fen) }

  describe '#moves_from_source' do
    context 'with default board' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns all the valid moves of white pawn' do
        cell = :g2
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[g3 g4] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white rook' do
        cell = :a1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white knight' do
        cell = :g1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[f3 h3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white bishop' do
        cell = :f1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white queen' do
        cell = :d1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white king' do
        cell = :e1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black pawn' do
        cell = :a7
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[a6 a5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black rook' do
        cell = :a8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black knight' do
        cell = :b8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[a6 c6] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black bishop' do
        cell = :f8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black queen' do
        cell = :d8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black king' do
        cell = :e8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with custom board' do
      let(:fen) { 'rn1qk3/1p3ppp/Q4n2/1Pppp1bb/2PR1r2/1N1P1P1N/P3P1PP/2B1KB1R w Kq - 0 1' }

      it 'returns all the valid moves of white pawn' do
        cell = :c4
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:d5], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white rook' do
        cell = :d4
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: %i[d5 f4], empty: [:e4] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white knight' do
        cell = :b3
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:c5], empty: %i[a5 d2 a1] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white bishop' do
        cell = :c1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:f4], empty: %i[b2 a3 d2 e3] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white queen' do
        cell = :a6
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: %i[a8 f6 b7], empty: %i[a7 b6 c6 d6 e6 a3 a4 a5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white king' do
        cell = :e1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[d1 d2 f2] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black pawn' do
        cell = :d5
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:c4], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black rook' do
        cell = :a8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:a6], empty: [:a7] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black knight' do
        cell = :f6
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[g8 g4 e4 d7] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black bishop' do
        cell = :h5
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:f3], empty: %i[g6 g4] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black queen' do
        cell = :d8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[c8 d7 d6 e7 c7 b6 a5] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black king' do
        cell = :e8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[f8 e7 d7] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with white king in check' do
      let(:fen) { '2r1k3/3pbp2/p2np1pn/1pp3Br/3PNPPp/RN1Q1bqB/PPP4P/4K1R1 w - - 0 1' }

      it 'returns all the valid moves of white king' do
        cell = :e1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: %i[d2 f1] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white rook' do
        cell = :g1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:g3], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white queen' do
        cell = :d3
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white pawn' do
        cell = :h2
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:g3], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white knight' do
        cell = :e4
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:g3], empty: [:f2] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white rook' do
        cell = :a3
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with black king in check' do
      let(:fen) { '1nr1k3/6R1/pBQpp1Nn/1ppP1p1r/3b1PPp/1N3bq1/PPPK3P/6R1 b - - 0 1' }

      it 'returns all the valid moves of black king' do
        cell = :e8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black rook' do
        cell = :c8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:c6], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black knight' do
        cell = :b8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:c6], empty: [:d7] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black pawn' do
        cell = :d6
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black bishop' do
        cell = :e8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black queen' do
        cell = :e8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with white king in checkmate' do
      let(:fen) { '1nr1k3/1Q4R1/pB1pp1N1/1ppP1p2/4bPPp/1N1nbq2/P1P3rP/2PK4 w - - 0 1' }

      it 'returns all the valid moves of white king' do
        cell = :d1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white queen' do
        cell = :b7
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white bishop' do
        cell = :b6
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white rook' do
        cell = :g7
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white knight' do
        cell = :b3
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white pawn' do
        cell = :c2
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with black king in checkmate' do
      let(:fen) { '1n2k1Q1/6R1/pB1pp1N1/1ppP1p2/4bPPp/1N1nbq2/P1P3rP/1KP5 b - - 0 1' }

      it 'returns all the valid moves of black king' do
        cell = :e8
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black queen' do
        cell = :f3
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black rook' do
        cell = :g2
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black knight' do
        cell = :d3
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black bishop' do
        cell = :e4
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black pawn' do
        cell = :f5
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with white king in stalemate' do
      let(:fen) { '1nP1k3/8/8/3b4/q6p/3nb3/6r1/1K6 w - - 0 1' }

      it 'returns all the valid moves of white king' do
        cell = :b1
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of white pawn' do
        cell = :c8
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'with black king in stalemate' do
      let(:fen) { '5R2/1Q2B1N1/8/4k3/2K3B1/8/8/2p2p2 b - - 0 1' }

      it 'returns all the valid moves of black king' do
        cell = :e5
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black pawn' do
        cell = :f1
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end

      it 'returns all the valid moves of black pawn' do
        cell = :c1
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'when white can take en_passant' do
      let(:fen) { 'rnbqk1nr/p1pp3p/5p1b/P3pPp1/1pP1P3/RB5Q/1P1P2PP/1NB1K1NR b Kkq g6 0 1' }

      it 'returns all the valid moves including en_passant move' do
        cell = :f5
        color = 'white'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: [:g6], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'when black can take en_passant' do
      let(:fen) { 'rnbqk1nr/p1pp3p/5p1b/P3pPp1/1pP1P3/RB5Q/1P1P2PP/1NB1K1NR b Kkq c3 0 1' }

      it 'returns all the valid moves including en_passant move' do
        cell = :b4
        color = 'black'
        result = board_operator.moves_from_source(cell, color)
        expected_result = { captures: %i[a3 c3], empty: [] }
        result.each { |k, v| result[k] = v.sort }
        expected_result.each { |k, v| expected_result[k] = v.sort }
        expect(result).to eq(expected_result)
      end
    end

    context 'castling' do
      context 'for white' do
        context 'when queen side castling available' do
          let(:fen) { 'r3k2r/3n3q/n7/6Q1/8/3R4/8/R3K2R w KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d2 e2 f2 d1 f1 g1 c1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when king side castling available' do
          let(:fen) { 'r3k2r/3n3q/n7/6Q1/8/3R4/8/R3K2R w KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d2 e2 f2 d1 f1 g1 c1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when castling not available' do
          let(:fen) { 'r3k2r/3n4/n7/6q1/8/8/8/R1R1K2R w KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[e2 f2 d1 f1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when source is not a king' do
          let(:fen) { '4k2r/3n4/n7/6q1/8/8/2r5/1RR1K2R w Kk - 0 1' }

          it 'returns all the valid moves' do
            cell = :c1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [:c2], empty: %i[d1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when the king in check' do
          let(:fen) { '4k2r/3n4/n7/4q3/8/8/2r5/1RR1K2R w Kk - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d1 f1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when castling leads to check' do
          let(:fen) { 'r1r1k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d1 d2 e2 f1 f2 g1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when the moves between queen side rook and king not empty' do
          let(:fen) { 'q2rk2r/3n4/8/8/8/8/8/Rb2K2R w KQk - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d2 e2 f2 d1 f1 g1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when the moves between king side rook and king not empty' do
          let(:fen) { '1b1rk2r/3n3q/8/8/8/8/8/R3K1pR w KQk - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d2 e2 f2 d1 f1 c1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when queen side castling move don\'t have adjacent move' do
          let(:fen) { '1b2k2r/3n1q2/3r1p2/8/8/8/8/R3K2R w KQk - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[e2 f1 f2 g1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when king side castling move don\'t have adjacent move' do
          let(:fen) { '1b2k2r/3n1q2/3r4/3p4/8/8/8/R3K2R w KQk - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[e2 d1 d2 c1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when castling rights empty' do
          let(:fen) { '1b1rk2r/3n3q/8/8/8/8/8/R3K1pR w - - 0 1' }

          it 'returns all the valid moves' do
            cell = :e1
            color = 'white'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d2 e2 f2 d1 f1] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end
      end

      context 'for black' do
        context 'when queen side castling available' do
          let(:fen) { 'r3k1pr/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d7 e7 f7 d8 f8 c8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when king side castling available' do
          let(:fen) { 'r1p1k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d7 e7 f7 d8 f8 g8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when castling not available' do
          let(:fen) { 'r1p1k1pr/8/8/8/8/8/8/R3K2R b KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d7 e7 f7 d8 f8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when source is not a king' do
          let(:fen) { 'r1p1k1pr/b7/8/8/8/8/8/R3K2R b KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :a8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[b8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when the king in check' do
          let(:fen) { 'r1p1k1pr/b7/8/8/8/8/4R3/4K2R b Kkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d8 f7 d7 f8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when castling leads to check' do
          let(:fen) { 'r1r1k2r/8/8/8/8/8/8/R3K1QR w KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d8 d7 e7 f8 f7] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when the moves between queen side rook and king not empty' do
          let(:fen) { 'rp2k1pr/b7/8/8/8/8/8/R3K2R b KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d7 e7 f7 d8 f8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when the moves between king side rook and king not empty' do
          let(:fen) { 'rp2k1pr/b7/8/8/8/8/8/R3K2R b KQkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d7 e7 f7 d8 f8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when queen side castling move don\'t have adjacent move' do
          let(:fen) { 'r3k2r/bp5p/8/8/8/8/8/R2RK3 b Qkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[e7 f7 f8 g8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when king side castling move don\'t have adjacent move' do
          let(:fen) { 'r3k2r/bp5p/8/8/8/8/8/R3KR2 b Qkq - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[e7 d7 d8 c8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end

        context 'when castling rights empty' do
          let(:fen) { 'r3k2r/bp5p/8/8/8/8/8/R3K2R b - - 0 1' }

          it 'returns all the valid moves' do
            cell = :e8
            color = 'black'
            result = board_operator.moves_from_source(cell, color)
            expected_result = { captures: [], empty: %i[d7 e7 f7 d8 f8] }
            result.each { |k, v| result[k] = v.sort }
            expected_result.each { |k, v| expected_result[k] = v.sort }
            expect(result).to eq(expected_result)
          end
        end
      end
    end
  end
end
