#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#make_move' do
    context 'with default fen board' do
      context 'when a2 moves to a4' do
        it 'moves a2 to a4' do
          chess_board = board.instance_variable_get(:@board)
          source = :a2
          destination = :a4
          previous_source_piece = chess_board[:a2].piece
          board.make_move(source, destination)
          expect(chess_board[:a2].piece).to be_nil
          expect(chess_board[:a4].piece).to eq(previous_source_piece)
        end
      end

      context 'when g1 moves to f3' do
        it 'moves g1 to f3' do
          chess_board = board.instance_variable_get(:@board)
          source = :g1
          destination = :f3
          previous_source_piece = chess_board[:g1].piece
          board.make_move(source, destination)
          expect(chess_board[:g1].piece).to be_nil
          expect(chess_board[:f3].piece).to eq(previous_source_piece)
        end
      end
    end

    context 'with custom fen board' do
      subject(:board) { described_class.new(fen) }
      let(:fen) do
        'rnb1kbnr/ppp2ppp/3ppq2/8/8/BPN5/P1PPPPPP/R2QKBNR w KQkq - 0 4'
      end

      context 'when a3 moves to c5' do
        it 'moves a3 to c5' do
          chess_board = board.instance_variable_get(:@board)
          source = :a3
          destination = :c5
          previous_source_piece = chess_board[:a3].piece
          board.make_move(source, destination)
          expect(chess_board[:a3].piece).to be_nil
          expect(chess_board[:c5].piece).to eq(previous_source_piece)
        end
      end

      context 'when g1 moves to h3' do
        it 'moves g1 to h3' do
          chess_board = board.instance_variable_get(:@board)
          source = :g1
          destination = :h3
          previous_source_piece = chess_board[:g1].piece
          board.make_move(source, destination)
          expect(chess_board[:g1].piece).to be_nil
          expect(chess_board[:h3].piece).to eq(previous_source_piece)
        end
      end
    end
  end
end
