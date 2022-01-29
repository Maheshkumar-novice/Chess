#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/components/creators/name-creator'

describe NameCreator do
  subject(:name_creator) { described_class.new }

  describe '#bot_name' do
    it 'returns a string' do
      name = name_creator.bot_name
      expect(name).to be_a(String)
    end
  end

  describe '#human_name' do
    before do
      allow(name_creator).to receive(:print_prompt)
      allow(name_creator).to receive(:gets).and_return('a name')
    end

    it 'returns a string' do
      name = name_creator.human_name
      expect(name).to be_a(String)
    end
  end
end
