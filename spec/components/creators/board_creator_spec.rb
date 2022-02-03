#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/components/creators/board-creator'
require_relative '../../../lib/board/fen-processor'

describe BoardCreator do
  subject(:board_creator) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
  let(:pieces) { fen_processor.pieces }
  before { fen_processor.process(fen) }

  describe '#create_board' do
    it 'returns a hash' do
      result = board_creator.create_board(pieces)
      expect(result).to be_a(Hash)
    end

    it 'returns a 64 element board' do
      result = board_creator.create_board(pieces).size
      expect(result).to eq(64)
    end

    it 'returns a board with first key as :a8' do
      result = board_creator.create_board(pieces).first[0]
      expect(result).to eq(:a8)
    end

    it 'returns a board with last key as :h1' do
      result = board_creator.create_board(pieces).keys.last
      expect(result).to eq(:h1)
    end
  end
end
