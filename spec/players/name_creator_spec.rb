#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/name-creator'

describe NameCreator do
  subject(:name_creator) { described_class.new }

  describe '#bot_name' do
    it 'returns a string' do
      name = name_creator.bot_name
      result = name.is_a?(String)
      expect(result).to eq true
    end
  end

  describe '#human_name' do
    before do
      allow(name_creator).to receive(:print)
      allow(name_creator).to receive(:gets).and_return('a name')
    end

    it 'returns a string' do
      name = name_creator.human_name
      result = name.is_a?(String)
      expect(result).to eq true
    end
  end
end
