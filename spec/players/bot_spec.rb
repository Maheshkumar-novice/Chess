#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/bot'

describe Bot do
  subject(:bot) { described_class.new }

  describe '#make_choice' do
    it 'returns a string' do
      result = bot.make_choice
      expect(result).to be_a(String)
    end
  end

  describe '#create_name' do
    it 'creates a name' do
      bot.create_name
      name = bot.instance_variable_get(:@name)
      expect(name).not_to be_nil
    end
  end
end
