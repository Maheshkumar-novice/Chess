#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/players/components/cell-choice-maker'

describe CellChoiceMaker do
  subject(:cell_choice_maker) { described_class.new }

  describe '#bot_choice' do
    it 'returns a string' do
      name = cell_choice_maker.bot_choice
      result = name.is_a?(String)
      expect(result).to eq true
    end
  end

  describe '#human_choice' do
    before do
      allow(cell_choice_maker).to receive(:print)
      allow(cell_choice_maker).to receive(:gets).and_return('a name')
    end

    it 'returns a string' do
      name = cell_choice_maker.human_choice
      result = name.is_a?(String)
      expect(result).to eq true
    end
  end
end
