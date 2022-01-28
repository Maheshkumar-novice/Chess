#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/pieces/piece'

describe Piece do
  subject(:piece) { described_class.new(Object.new, Object.new) }

  describe '#color?' do
    before { piece.color = 'white' }

    context 'when the colors match' do
      it 'returns true' do
        result = piece.color?('white')
        expect(result).to eq(true)
      end
    end

    context 'when the colors don\'t match' do
      it 'returns false' do
        result = piece.color?('black')
        expect(result).to eq(false)
      end
    end
  end
end
