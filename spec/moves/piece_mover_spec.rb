#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/moves/piece-mover'
require_relative '../../lib/fen/fen-processor'
require_relative '../../lib/board/utils/board-creator'

describe PieceMover do
  subject(:piece_mover) { described_class.new }
  let(:board) { board_creator.create_board(fen_processor.pieces) }
  let(:meta_data) { fen_processor.meta_data }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  before { fen_processor.process(fen) }

  describe '#regular_move' do
    let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

    it 'moves the piece from a2 to a4' do
      source = :a2
      destination = :a4
      previous_source_piece = board[source].piece
      piece_mover.regular_move(source, destination, board, meta_data)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end

    it 'moves the piece from g7 to g6' do
      source = :g7
      destination = :g6
      previous_source_piece = board[source].piece
      piece_mover.regular_move(source, destination, board, meta_data)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end

    it 'moves the piece from b8 to a6' do
      source = :b8
      destination = :a6
      previous_source_piece = board[source].piece
      piece_mover.regular_move(source, destination, board, meta_data)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end

    it 'moves the piece from e7 to e6' do
      source = :e7
      destination = :e6
      previous_source_piece = board[source].piece
      piece_mover.regular_move(source, destination, board, meta_data)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end
  end

  describe '#take_en_passant' do
    let(:fen) { 'rnbqkbnr/p2p3p/8/2pPPp2/Pp4pP/8/1PP2PP1/RNBQKBNR w KQkq b4 0 1' }

    it 'takes passant from a4' do
      source = :b4
      destination = :a3
      en_passant_capture_cell = :a4
      previous_source_piece = board[source].piece
      piece_mover.take_en_passant(source, destination, board, meta_data)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
      expect(board[en_passant_capture_cell].piece).to be_nil
    end

    it 'takes passant from c5' do
      source = :d5
      destination = :c6
      en_passant_capture_cell = :c5
      previous_source_piece = board[source].piece
      piece_mover.take_en_passant(source, destination, board, meta_data)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
      expect(board[en_passant_capture_cell].piece).to be_nil
    end

    it 'takes passant from f5' do
      source = :e5
      destination = :f6
      en_passant_capture_cell = :f5
      previous_source_piece = board[source].piece
      piece_mover.take_en_passant(source, destination, board, meta_data)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
      expect(board[en_passant_capture_cell].piece).to be_nil
    end

    it 'takes passant from h4' do
      source = :g4
      destination = :h3
      en_passant_capture_cell = :h4
      previous_source_piece = board[source].piece
      piece_mover.take_en_passant(source, destination, board, meta_data)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
      expect(board[en_passant_capture_cell].piece).to be_nil
    end
  end

  describe '#castling' do
    let(:fen) { 'r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1' }

    context 'for white' do
      context 'for queen side castling' do
        it 'makes queen side castling' do
          source = :e1
          destination = :c1
          rook_source = :a1
          rook_destination = :d1
          previous_rook_source = board[rook_source].piece
          previous_source_piece = board[source].piece
          piece_mover.castling(source, destination, board, meta_data)
          current_source_piece = board[source].piece
          current_destination_piece = board[destination].piece
          current_rook_source = board[rook_source].piece
          current_rook_destination = board[rook_destination].piece
          expect(current_source_piece).to eq(nil)
          expect(current_destination_piece).to eq(previous_source_piece)
          expect(current_rook_source).to eq(nil)
          expect(current_rook_destination).to eq(previous_rook_source)
        end
      end

      context 'for king side castling' do
        it 'makes king side castling' do
          source = :e1
          destination = :g1
          rook_source = :h1
          rook_destination = :f1
          previous_rook_source = board[rook_source].piece
          previous_source_piece = board[source].piece
          piece_mover.castling(source, destination, board, meta_data)
          current_source_piece = board[source].piece
          current_destination_piece = board[destination].piece
          current_rook_source = board[rook_source].piece
          current_rook_destination = board[rook_destination].piece
          expect(current_source_piece).to eq(nil)
          expect(current_destination_piece).to eq(previous_source_piece)
          expect(current_rook_source).to eq(nil)
          expect(current_rook_destination).to eq(previous_rook_source)
        end
      end
    end

    context 'for black' do
      context 'for queen side castling' do
        it 'makes queen side castling' do
          source = :e8
          destination = :c8
          rook_source = :a8
          rook_destination = :d8
          previous_rook_source = board[rook_source].piece
          previous_source_piece = board[source].piece
          piece_mover.castling(source, destination, board, meta_data)
          current_source_piece = board[source].piece
          current_destination_piece = board[destination].piece
          current_rook_source = board[rook_source].piece
          current_rook_destination = board[rook_destination].piece
          expect(current_source_piece).to eq(nil)
          expect(current_destination_piece).to eq(previous_source_piece)
          expect(current_rook_source).to eq(nil)
          expect(current_rook_destination).to eq(previous_rook_source)
        end
      end

      context 'for king side castling' do
        it 'makes king side castling' do
          source = :e8
          destination = :g8
          rook_source = :h8
          rook_destination = :f8
          previous_rook_source = board[rook_source].piece
          previous_source_piece = board[source].piece
          piece_mover.castling(source, destination, board, meta_data)
          current_source_piece = board[source].piece
          current_destination_piece = board[destination].piece
          current_rook_source = board[rook_source].piece
          current_rook_destination = board[rook_destination].piece
          expect(current_source_piece).to eq(nil)
          expect(current_destination_piece).to eq(previous_source_piece)
          expect(current_rook_source).to eq(nil)
          expect(current_rook_destination).to eq(previous_rook_source)
        end
      end
    end
  end
end
