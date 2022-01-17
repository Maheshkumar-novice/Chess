#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/player'

describe Player do
  subject(:player) { described_class.new }

  describe '#valid_name?' do
    context 'when the name with special characters given' do
      it 'returns false' do
        name = 'a$da!'
        result = player.valid_name?(name)
        expect(result).to eq false
      end
    end

    context 'when an empty name given' do
      it 'returns false' do
        name = ''
        result = player.valid_name?(name)
        expect(result).to eq false
      end
    end

    context 'when the name size is greater than max size' do
      it 'returns false' do
        name = 'abcdefghijklmnopqrstuvwxyz'
        result = player.valid_name?(name)
        expect(result).to eq false
      end
    end

    context 'when the name with only whitespace given' do
      it 'returns false' do
        name = '       \n\t'
        result = player.valid_name?(name)
        expect(result).to eq false
      end
    end

    context 'when a valid name given' do
      it 'returns true' do
        name = 'fine good name'
        result = player.valid_name?(name)
        expect(result).to eq true
      end
    end

    context 'when capital letters are used in the valid name' do
      it 'returns true' do
        name = 'Abdae'
        result = player.valid_name?(name)
        expect(result).to eq true
      end
    end
  end
end
