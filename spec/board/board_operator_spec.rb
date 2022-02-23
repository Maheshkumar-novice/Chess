#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board/board-operator'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe BoardOperator do
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  let(:piece_mover) { instance_double(PieceMover) }
  before do
    fen_processor.process(fen)
    allow(piece_mover).to receive(:move_piece)
  end

  describe '#make_move' do
    context 'message verifications' do
      subject(:board_operator) { described_class.new(board, meta_data, piece_mover: piece_mover) }
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
      let(:board) { {} }
      let(:meta_data) { double('MetaData') }
      let(:source) { :a4 }
      let(:destination) { :b2 }

      before do
        allow(meta_data).to receive(:update)
        allow(meta_data).to receive(:special_moves_state)
      end

      it 'sends :special_moves_state message to meta_data' do
        meta_data = board_operator.instance_variable_get(:@meta_data)
        expect(meta_data).to receive(:special_moves_state)
        board_operator.make_move(source, destination)
      end

      it 'sends :update message to meta_data' do
        meta_data = board_operator.instance_variable_get(:@meta_data)
        expect(meta_data).to receive(:update)
        board_operator.make_move(source, destination)
      end

      it 'sends :move_piece message to piece_mover' do
        piece_mover = board_operator.instance_variable_get(:@piece_mover)
        expect(piece_mover).to receive(:move_piece)
        board_operator.make_move(source, destination)
      end
    end

    context 'state verifications' do
      let(:board) { board_creator.create_board(fen_processor.pieces) }
      let(:meta_data) { fen_processor.meta_data }
      subject(:board_operator) { described_class.new(board, meta_data) }

      context 'when tried to make a regular move' do
        let(:fen) { 'rn1qkbnr/p2p1p1p/2P3p1/4p3/P6B/1P6/3QPPPP/RN2KBNR w KQkq - 0 1' }

        before do
          allow(meta_data).to receive(:special_moves_state).and_return({})
        end

        it 'makes the move' do
          source = :d2
          destination = :d7
          previous_source_piece = board[source].piece
          board_operator.make_move(source, destination)
          current_source_piece = board[source].piece
          current_destinatin_piece = board[destination].piece
          expect(current_source_piece).to be_nil
          expect(current_destinatin_piece).to eq(previous_source_piece)
        end
      end

      context 'when tried to make an en_passant move' do
        let(:fen) { 'rn1qkbnr/p4p1p/6p1/2Ppp3/P6B/1P6/3QPPPP/RN2KBNR w KQkq d6 0 1' }

        before do
          allow(meta_data).to receive(:special_moves_state).and_return({ en_passant: true })
        end

        it 'makes the move' do
          source = :c5
          destination = :d6
          en_passant_piece_cell = :d5
          previous_source_piece = board[source].piece
          board_operator.make_move(source, destination)
          current_source_piece = board[source].piece
          current_destinatin_piece = board[destination].piece
          current_en_passant_piece = board[en_passant_piece_cell].piece
          expect(current_source_piece).to be_nil
          expect(current_destinatin_piece).to eq(previous_source_piece)
          expect(current_en_passant_piece).to eq(nil)
        end
      end

      context 'when the move creates en_passant possibility' do
        let(:fen) { 'rn1qkbnr/p2p1p1p/6p1/2P1p3/P6B/1P6/3QPPPP/RN2KBNR w KQkq d6 0 1' }

        before do
          allow(meta_data).to receive(:special_moves_state).and_return({ en_passant: false })
        end

        it 'updates en_passant cell to a cell marker' do
          source = :d7
          destination = :d5
          board_operator.make_move(source, destination)
          result = meta_data.en_passant_move
          expect(result).to eq(:d6)
        end
      end

      context 'when the move doesn\'t create en_passant possibility' do
        let(:fen) { 'rn1qkbnr/p2p1p1p/6p1/2P1p3/P6B/1P6/3QPPPP/RN2KBNR w KQkq d6 0 1' }

        before do
          allow(meta_data).to receive(:special_moves_state).and_return({ en_passant: true })
        end

        it 'updates en_passant cell to be not a cell marker' do
          source = :f2
          destination = :f3
          board_operator.make_move(source, destination)
          result = meta_data.en_passant_move
          expect(result).to eq(:-)
        end
      end
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

    context 'when white king is in check after promotion' do
      let(:fen) { 'N6k/1PPQPP2/6PP/8/8/1p6/3ppppp/K1r5 w - - 0 1' }

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

    context 'when white king is not in check after promotion' do
      let(:fen) { 'N6k/1PPQPP2/6PP/8/8/1p6/3ppppp/K1b5 w - - 0 1' }

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

    context 'when black king is in check after promotion' do
      let(:fen) { 'Q6k/1PPQPP2/6PP/1K6/8/8/1ppppppp/8 w - - 0 1' }

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

    context 'when black king is not in check after promotion' do
      let(:fen) { 'N6k/1PPQPP2/6PP/1K6/8/8/1ppppppp/8 w - - 0 1' }

      it 'returns false' do
        result = board_operator.king_in_check?('black')
        expect(result).to eq(false)
      end
    end
  end

  describe '#checkmate?' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'when white king is in checkmate' do
      let(:fen) { 'rnb1kbnr/pppp1ppp/4p3/8/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 0 1' }

      it 'returns true' do
        result = board_operator.checkmate?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is in checkmate after promotion' do
      let(:fen) { '8/8/8/8/8/8/r7/3K1q2 w - - 0 1' }

      it 'returns true' do
        result = board_operator.checkmate?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is not in checkmate' do
      let(:fen) { 'rnb1kbnr/pppp1ppp/4p3/8/7q/5P2/PPPPP1PP/RNBQKBNR w KQkq - 0 1' }

      it 'returns false' do
        result = board_operator.checkmate?('white')
        expect(result).to eq(false)
      end
    end

    context 'when black king is in checkmate' do
      let(:fen) { 'rnb3nr/pp3ppp/4p3/1k2Q1b1/5P1q/RP1N1B2/P1PPPBPP/4K1NR w K - 0 1' }

      it 'returns true' do
        result = board_operator.checkmate?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is in checkmate after promotion' do
      let(:fen) { '1QB5/k7/8/8/8/2B5/8/1R6 w - - 0 1' }

      it 'returns true' do
        result = board_operator.checkmate?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is not in checkmate' do
      let(:fen) { 'rnb3nr/pp3ppp/4pb2/1k2Q3/5P1q/RP1N1B2/P1PPPBPP/4K1NR w K - 0 1' }

      it 'returns false' do
        result = board_operator.checkmate?('black')
        expect(result).to eq(false)
      end
    end
  end

  describe '#stalemate?' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'when white king is in stalemate' do
      let(:fen) { '2P4K/p7/8/1k6/4brq1/8/8/8 w - - 0 1' }

      it 'returns true' do
        result = board_operator.stalemate?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is in stalemate after promotion' do
      let(:fen) { '7k/8/8/8/1q6/8/2qppppp/K7 w - - 0 1' }

      it 'returns true' do
        result = board_operator.stalemate?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is not in stalemate' do
      let(:fen) { '2P4K/p7/8/1k6/4brq1/8/8/2Q5 w - - 0 1' }

      it 'returns false' do
        result = board_operator.stalemate?('white')
        expect(result).to eq(false)
      end
    end

    context 'when black king is in stalemate' do
      let(:fen) { '2P4K/8/7R/k7/6R1/8/8/1Q6 w - - 0 1' }

      it 'returns true' do
        result = board_operator.stalemate?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is in stalemate after promotion' do
      let(:fen) { '1Q2B3/8/k7/8/8/2B5/8/1R6 w - - 0 1' }

      it 'returns true' do
        result = board_operator.stalemate?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is not in stalemate' do
      let(:fen) { '2P4K/1p6/7R/k7/6R1/8/8/1Q6 w - - 0 1' }

      it 'returns false' do
        result = board_operator.stalemate?('black')
        expect(result).to eq(false)
      end
    end
  end

  describe '#color_has_no_legal_moves?' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'when white has no legal moves' do
      let(:fen) { '2P4K/p7/8/1k6/4brq1/8/8/8 w - - 0 1' }

      it 'returns true' do
        result = board_operator.color_has_no_legal_moves?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white has legal moves' do
      let(:fen) { '2P4K/1p6/7R/k7/6R1/8/8/1Q6 w - - 0 1' }

      it 'returns false' do
        result = board_operator.color_has_no_legal_moves?('white')
        expect(result).to eq(false)
      end
    end

    context 'when black has no legal moves' do
      let(:fen) { '2P4K/8/7R/k7/6R1/8/8/1Qp5 w - - 0 1' }

      it 'returns true' do
        result = board_operator.color_has_no_legal_moves?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black has legal moves' do
      let(:fen) { '2P4K/8/7R/k7/6R1/8/1r6/1Qp5 w - - 0 1' }

      it 'returns false' do
        result = board_operator.color_has_no_legal_moves?('black')
        expect(result).to eq(false)
      end
    end
  end

  describe '#remove_allies' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'for white color' do
      let(:fen) { '1nb2b1k/2qpp1rp/rp2P3/1p1Q1Pp1/2P1n3/p1B1p2P/PP1N1PPR/R3KBN1 w Q - 0 1' }

      before { board_operator.instance_variable_set(:@moves, %i[c6 d6 e6 c5 d5 e5 c4 d4 e4]) }

      it 'removes allies' do
        board_operator.remove_allies('white')
        result = board_operator.instance_variable_get(:@moves)
        expected_result = %i[c6 d6 c5 e5 d4 e4]
        expect(result).to eq(expected_result)
      end
    end

    context 'for black color' do
      let(:fen) { '1nb2b1k/2qpp1rp/rp2P3/1p1Q1Pp1/2P1n3/p1B1p2P/PP1N1PPR/R3KBN1 w Q - 0 1' }

      before { board_operator.instance_variable_set(:@moves, %i[c8 d8 e8 c7 d7 e7 c6 d6 e6]) }

      it 'removes allies' do
        board_operator.remove_allies('black')
        result = board_operator.instance_variable_get(:@moves)
        expected_result = %i[d8 e8 c6 d6 e6]
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#remove_moves_that_leads_to_check' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'for white color' do
      let(:fen) { '1nb4k/2qpp1rp/rp2P3/1p1Q1Pp1/1bP1n3/p3p2P/PPBN1PPR/R3KBN1 w Q - 0 1' }

      before { board_operator.instance_variable_set(:@moves, %i[e4 f3 b1 b3]) }

      it 'removes moves that leads to check' do
        board_operator.remove_moves_that_leads_to_check(:d2, 'white')
        result = board_operator.instance_variable_get(:@moves)
        expected_result = []
        expect(result).to eq(expected_result)
      end

      context 'when white en_passant leads to check' do
        let(:fen) { 'rnbqk1nr/p1ppp2p/5p1b/P3QPp1/1pP1P3/RP2K3/3P2PP/1NB2BNR w kq g6 0 1' }

        before { board_operator.instance_variable_set(:@moves, %i[e6 g6]) }

        it 'removes that move' do
          board_operator.remove_moves_that_leads_to_check(:f5, 'white')
          result = board_operator.instance_variable_get(:@moves)
          expected_result = [:e6]
          expect(result).to eq(expected_result)
        end
      end
    end

    context 'for black color' do
      let(:fen) { '1nb2r1k/3pp3/rp2P2q/1p1Q1pp1/1bP1n2R/p3p2P/PPBN1PP1/R3KBN1 w Q - 0 1' }

      before { board_operator.instance_variable_set(:@moves, %i[h7 h5 h4 g6 f6 e6 g7]) }

      it 'removes moves that leads to check' do
        board_operator.remove_moves_that_leads_to_check(:h6, 'black')
        result = board_operator.instance_variable_get(:@moves)
        expected_result = %i[h7 h5 h4]
        expect(result).to eq(expected_result)
      end

      context 'when black en_passant leads to check' do
        let(:fen) { 'rnbq2nr/p1pp1k1p/5p1b/P3pPp1/1pP1P3/RB2K2Q/1P1P2PP/1NB3NR b - c3 0 1' }

        before { board_operator.instance_variable_set(:@moves, %i[a3 c3]) }

        it 'removes that move' do
          board_operator.remove_moves_that_leads_to_check(:b4, 'black')
          result = board_operator.instance_variable_get(:@moves)
          expected_result = [:a3]
          expect(result).to eq(expected_result)
        end
      end
    end
  end

  describe '#find_king_position' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'for white color' do
      let(:fen) { '1nb4k/2qpp1rp/rp2P3/1p1Q1Pp1/1bP1n3/p3p2P/PPBN1PPR/R3KBN1 w Q - 0 1' }

      it 'finds king position' do
        result = board_operator.find_king_position('white')
        expected_result = :e1
        expect(result).to eq(expected_result)
      end
    end

    context 'for black color' do
      let(:fen) { '1nb2r1k/3pp3/rp2P2q/1p1Q1pp1/1bP1n2R/p3p2P/PPBN1PP1/R3KBN1 w Q - 0 1' }

      it 'finds king position' do
        result = board_operator.find_king_position('black')
        expected_result = :h8
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#move_leads_to_check?' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'when the move leads to white king check' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb6/1P6/2PQPPPP/RNB1KBNR w KQkq - 0 1' }

      it 'returns true' do
        source = :d2
        destination = :d1
        color = 'white'
        result = board_operator.move_leads_to_check?(source, destination, color)
        expect(result).to eq(true)
      end
    end

    context 'when the move leads to black king check' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb5B/1P6/2PQPPPP/RN2KBNR w KQkq - 0 1' }

      it 'returns true' do
        source = :e8
        destination = :e7
        color = 'black'
        result = board_operator.move_leads_to_check?(source, destination, color)
        expect(result).to eq(true)
      end
    end

    context 'when the move doesn\'t lead to white king check' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb5B/1P6/2PQPPPP/RN2KBNR w KQkq - 0 1' }

      it 'returns false' do
        source = :h4
        destination = :d8
        color = 'white'
        result = board_operator.move_leads_to_check?(source, destination, color)
        expect(result).to eq(false)
      end
    end

    context 'when the move doesn\'t lead to black king check' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb5B/1P6/2PQPPPP/RN2KBNR w KQkq - 0 1' }

      it 'returns false' do
        source = :f8
        destination = :c5
        color = 'black'
        result = board_operator.move_leads_to_check?(source, destination, color)
        expect(result).to eq(false)
      end
    end
  end

  describe '#revert_move' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }

    context 'for a regular move' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/PP5B/1P6/3QPPPP/RN2KBNR w KQkq - 0 1' }

      before do
        pieces_changed = { c3: 'pawn', b4: 'bishop' }
        allow(meta_data).to receive(:pieces_changed).and_return(pieces_changed)
        allow(board[:c3]).to receive(:update_current_cell_of_piece)
        allow(board[:b4]).to receive(:update_current_cell_of_piece)
      end

      it 'reverts the move' do
        board_operator.revert_move
        result = [board[:c3].piece, board[:b4].piece]
        expected_result = %w[pawn bishop]
        expect(result).to eq(expected_result)
      end
    end

    context 'for an en_passant move' do
      let(:fen) { 'rn1qkbnr/p2p1p1p/2P3p1/4p3/P6B/1P6/3QPPPP/RN2KBNR w KQkq - 0 1' }

      before do
        pieces_changed = { b5: 'pawn', c6: nil, c5: 'pawn' }
        allow(meta_data).to receive(:pieces_changed).and_return(pieces_changed)
        allow(board[:b5]).to receive(:update_current_cell_of_piece)
        allow(board[:c5]).to receive(:update_current_cell_of_piece)
      end

      it 'reverts the move' do
        board_operator.revert_move
        result = [board[:b5].piece, board[:c6].piece, board[:c5].piece]
        expected_result = ['pawn', nil, 'pawn']
        expect(result).to eq(expected_result)
      end
    end
  end
end
