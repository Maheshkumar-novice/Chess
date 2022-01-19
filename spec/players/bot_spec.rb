#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/bot'

describe Bot do
  subject(:bot) { described_class.new }

  describe '#make_choice' do
    let(:cell_choice_maker) { bot.instance_variable_get(:@cell_choice_maker) }

    it 'sends message bot_choice to cell_choice_maker once' do
      expect(cell_choice_maker).to receive(:bot_choice).once
      bot.make_choice
    end
  end

  describe '#create_name' do
    let(:name_creator) { bot.instance_variable_get(:@name_creator) }

    it 'sends message bot_name to name_creator' do
      expect(name_creator).to receive(:bot_name)
      bot.create_name
    end
  end
end
