#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/players-creator'

describe PlayersCreator do
  subject(:players_creator) { described_class.new }

  before do
    allow(players_creator).to receive(:print_error)
    allow(players_creator).to receive(:print_info)
    allow(players_creator).to receive(:accent)
  end

  describe '#create_players_of_mode' do
    context 'when the mode is a' do
      before do
        players_creator.instance_variable_set(:@mode, 'a')
      end

      it 'returns two bots' do
        players = players_creator.create_players_of_mode
        result = players.all? { |player| player.is_a?(Bot) }
        expect(result).to eq true
      end
    end

    context 'when the mode is b' do
      before do
        players_creator.instance_variable_set(:@mode, 'b')
      end

      it 'returns a bot and a human' do
        players = players_creator.create_players_of_mode
        result_bot = players[0].is_a?(Bot)
        result_human = players[1].is_a?(Human)
        result = result_bot && result_human
        expect(result).to eq true
      end
    end

    context 'when the mode is c' do
      before do
        players_creator.instance_variable_set(:@mode, 'c')
      end

      it 'returns a human and a bot' do
        players = players_creator.create_players_of_mode
        result_human = players[0].is_a?(Human)
        result_bot = players[1].is_a?(Bot)
        result = result_bot && result_human
        expect(result).to eq true
      end
    end

    context 'when the mode is d' do
      before do
        players_creator.instance_variable_set(:@mode, 'd')
      end

      it 'returns two humans' do
        players = players_creator.create_players_of_mode
        result = players.all? { |player| player.is_a?(Human) }
        expect(result).to eq true
      end
    end
  end

  describe '#create_names' do
    before do
      players_creator.instance_variable_set(:@mode, 'b')
      players = players_creator.create_players_of_mode
      players_creator.instance_variable_set(:@players, players)
    end

    it 'sends create_name message to the first player' do
      players = players_creator.instance_variable_get(:@players)
      allow(players[1]).to receive(:create_name)
      expect(players[0]).to receive(:create_name)
      players_creator.create_names
    end

    it 'sends create_name message to the second player' do
      players = players_creator.instance_variable_get(:@players)
      allow(players[0]).to receive(:create_name)
      expect(players[1]).to receive(:create_name)
      players_creator.create_names
    end
  end
end
