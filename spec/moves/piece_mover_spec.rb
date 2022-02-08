#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/moves/piece-mover'
require_relative '../../lib/fen/fen-processor'
require_relative '../../lib/board/utils/board-creator'

describe PieceMover do
  subject(:piece_mover) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  before { fen_processor.process(fen) }

  describe '#regular_move' do
    let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }

    it 'moves the piece from a2 to a4' do
      source = :a2
      destination = :a4
      previous_source_piece = board[source].piece
      piece_mover.regular_move(source, destination, board)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end

    it 'moves the piece from g7 to g6' do
      source = :g7
      destination = :g6
      previous_source_piece = board[source].piece
      piece_mover.regular_move(source, destination, board)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end

    it 'moves the piece from b8 to a6' do
      source = :b8
      destination = :a6
      previous_source_piece = board[source].piece
      piece_mover.regular_move(source, destination, board)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end

    it 'moves the piece from e7 to e6' do
      source = :e7
      destination = :e6
      previous_source_piece = board[source].piece
      piece_mover.regular_move(source, destination, board)
      expect(board[source].piece).to be_nil
      expect(board[destination].piece).to eq(previous_source_piece)
    end
  end
end
