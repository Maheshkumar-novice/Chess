#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/counters/counters'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe Counters do
  subject(:counters) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  let(:board) { board_creator.create_board(fen_processor.pieces) }
  let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
  before { fen_processor.process(fen) }

  describe '#update_counters' do
    context 'when half move valid' do
      context 'when pawn moves' do
        it 'resets the half move clock' do
          source = :a2
          destination = :a4
          color = 'white'
          counters.update_counters(source, destination, board, color)
          expect(counters.instance_variable_get(:@half_move_clock)).to be_zero
        end
      end

      context 'when capture happens' do
        let(:fen) { 'rnbqkbnr/1ppppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

        it 'resets the half move clock' do
          source = :b2
          destination = :a3
          color = 'white'
          counters.update_counters(source, destination, board, color)
          expect(counters.instance_variable_get(:@half_move_clock)).to be_zero
        end
      end
    end

    context 'when half move not valid' do
      it 'increments the half move clock' do
        source = :b1
        destination = :a3
        color = 'white'
        expect { counters.update_counters(source, destination, board, color) }.to change { counters.instance_variable_get(:@half_move_clock) }.by(1)
      end
    end

    context 'when full move' do
      it 'increments the full move number' do
        source = :c7
        destination = :c5
        color = 'black'
        expect { counters.update_counters(source, destination, board, color) }.to change { counters.instance_variable_get(:@full_move_number) }.by(1)
      end
    end
  end

  describe '#half_move_reset?' do
    context 'when the source is pawn' do
      it 'returns true' do
        source = :a2
        destination = :a4
        result = counters.half_move_reset?(source, destination, board)
        expect(result).to eq(true)
      end
    end

    context 'when the move is a capture' do
      let(:fen) { 'rnbqkbnr/1ppppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns true' do
        source = :b2
        destination = :a3
        result = counters.half_move_reset?(source, destination, board)
        expect(result).to eq(true)
      end
    end

    context 'when the source is not pawn and the move is not a capture' do
      it 'returns false' do
        source = :b1
        destination = :a3
        result = counters.half_move_reset?(source, destination, board)
        expect(result).to eq(false)
      end
    end
  end

  describe '#full_move?' do
    context 'when the color is black' do
      it 'returns true' do
        color = 'black'
        result = counters.full_move?(color)
        expect(result).to eq(true)
      end
    end

    context 'when the color is white' do
      it 'returns false' do
        color = 'white'
        result = counters.full_move?(color)
        expect(result).to eq(false)
      end
    end
  end

  describe '#increment_half_move_clock' do
    it 'increments half move clock by one' do
      expect { counters.increment_half_move_clock }.to change { counters.instance_variable_get(:@half_move_clock) }.by(1)
    end
  end

  describe '#increment_full_move_number' do
    it 'increments full_move_number by one' do
      expect { counters.increment_full_move_number }.to change { counters.instance_variable_get(:@full_move_number) }.by(1)
    end
  end

  describe '#reset_half_move_clock' do
    it 'resets half move clock to 0' do
      counters.reset_half_move_clock
      expect(counters.instance_variable_get(:@half_move_clock)).to be_zero
    end
  end

  describe '#fifty_move_rule?' do
    context 'when half move clock is 50' do
      before { counters.instance_variable_set(:@half_move_clock, 50) }

      it 'returns true' do
        result = counters.fifty_move_rule?
        expect(result).to eq(true)
      end
    end

    context 'when half move clock is 25' do
      before { counters.instance_variable_set(:@half_move_clock, 25) }

      it 'returns false' do
        result = counters.fifty_move_rule?
        expect(result).to eq(false)
      end
    end

    context 'when half move clock is 0' do
      before { counters.instance_variable_set(:@half_move_clock, 0) }

      it 'returns false' do
        result = counters.fifty_move_rule?
        expect(result).to eq(false)
      end
    end
  end

  describe '#to_s' do
    it 'returns the string form of half move clock and full move number combined' do
      result = counters.to_s
      expect(result).to eq('0 1')
    end
  end
end
