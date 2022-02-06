#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/cell/utils/cell-choice-creator'

describe CellChoiceCreator do
  subject(:cell_choice_creator) { described_class.new }

  describe '#bot_choice' do
    it 'returns a string' do
      name = cell_choice_creator.bot_choice
      expect(name).to be_a(String)
    end

    it 'returns a string of size 2' do
      size = cell_choice_creator.bot_choice.size
      expect(size).to eq(2)
    end
  end

  describe '#human_choice' do
    before do
      allow(cell_choice_creator).to receive(:print_prompt)
      allow($stdin).to receive(:gets).and_return('a name')
    end

    it 'returns a string' do
      name = cell_choice_creator.human_choice
      expect(name).to be_a(String)
    end
  end
end
