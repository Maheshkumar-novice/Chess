#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board/board-operator'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe BoardOperator do
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  before do
    fen_processor.process(fen)
  end

  describe '#moves_from_source' do
    let(:board) { board_creator.create_board(fen_processor.pieces) }
    let(:meta_data) { fen_processor.meta_data }
    subject(:board_operator) { described_class.new(board, meta_data) }
    
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
