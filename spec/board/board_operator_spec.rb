#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board/board-operator'
require_relative '../../lib/components/creators/board-creator'
require_relative '../../lib/board/fen'

describe BoardOperator do
  let(:fen_processor) { Fen.new }
  let(:board_creator) { BoardCreator.new }
  before { fen_processor.process(fen) }

  describe '#make_move' do
    let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    it 'makes move from a2 to a4' do
      source = :a2
      destination = :a4
      previous_source_piece = board[source].piece
      board_operator.make_move(source, destination)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end

    it 'makes move from b8 to a6' do
      source = :b8
      destination = :a6
      previous_source_piece = board[source].piece
      board_operator.make_move(source, destination)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end

    it 'makes move from e7 to e6' do
      source = :e7
      destination = :e6
      previous_source_piece = board[source].piece
      board_operator.make_move(source, destination)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end
  end

  describe '#moves_from_source' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

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
  end

  describe '#king_in_check?' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'when white king is in check' do
      let(:fen) { 'rnb1kbnr/pp1ppppp/2p5/8/1q6/3P4/PPP1PPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns true' do
        result = board_operator.king_in_check?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is not in check' do
      let(:fen) { 'rnb1kbnr/pp1ppppp/1qp5/8/8/3P4/PPP1PPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns false' do
        result = board_operator.king_in_check?('white')
        expect(result).to eq(false)
      end
    end

    context 'when black king is in check' do
      let(:fen) { 'rnb1kbnr/pp1pp1pp/1qp2p2/7B/8/3P1PP1/PPP1P2P/RNBQK1NR w KQkq - 0 1' }

      it 'returns true' do
        result = board_operator.king_in_check?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is not in check' do
      let(:fen) { 'rnb1kbnr/pp1ppppp/1qp5/7B/8/3P1PP1/PPP1P2P/RNBQK1NR w KQkq - 0 1' }

      it 'returns false' do
        result = board_operator.king_in_check?('black')
        expect(result).to eq(false)
      end
    end
  end
end
