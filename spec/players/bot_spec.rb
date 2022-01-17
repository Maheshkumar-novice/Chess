#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/bot'

describe Bot do
  subject(:bot) { described_class.new }

  describe '#input' do
    it 'returns a string' do
      result = bot.input.is_a?(String)
      expect(result).to eq true
    end
  end

  describe '#create_name' do
    it 'returns a string of size between 1 and 15' do
      bot.create_name
      result = bot.name.size.between?(1, 15)
      expect(result).to eq true
    end
  end
end
