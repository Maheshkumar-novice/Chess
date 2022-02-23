#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/players/utils/player-creator'

describe PlayerCreator do
  subject(:player_creator) { described_class.new }

  describe '#create_players_of_mode' do
    context 'when the mode is a' do
      before do
        player_creator.instance_variable_set(:@mode, 'a')
      end

      it 'returns two bots' do
        players = player_creator.create_players_of_mode
        expect(players).to all(be_a(Bot))
      end
    end

    context 'when the mode is b' do
      before do
        player_creator.instance_variable_set(:@mode, 'b')
      end

      it 'returns a bot and a human' do
        players = player_creator.create_players_of_mode
        result_bot = players[0].is_a?(Bot)
        result_human = players[1].is_a?(Human)
        result = result_bot && result_human
        expect(result).to eq true
      end
    end

    context 'when the mode is c' do
      before do
        player_creator.instance_variable_set(:@mode, 'c')
      end

      it 'returns a human and a bot' do
        players = player_creator.create_players_of_mode
        result_human = players[0].is_a?(Human)
        result_bot = players[1].is_a?(Bot)
        result = result_bot && result_human
        expect(result).to eq true
      end
    end

    context 'when the mode is d' do
      before do
        player_creator.instance_variable_set(:@mode, 'd')
      end

      it 'returns two humans' do
        players = player_creator.create_players_of_mode
        expect(players).to all(be_a(Human))
      end
    end
  end

  describe '#create_names' do
    before do
      player_creator.instance_variable_set(:@mode, 'b')
      players = player_creator.create_players_of_mode
      player_creator.instance_variable_set(:@players, players)
    end

    it 'sends create_name message to the first player' do
      players = player_creator.instance_variable_get(:@players)
      allow(players[1]).to receive(:create_name)
      expect(players[0]).to receive(:create_name)
      player_creator.create_names
    end

    it 'sends create_name message to the second player' do
      players = player_creator.instance_variable_get(:@players)
      allow(players[0]).to receive(:create_name)
      expect(players[1]).to receive(:create_name)
      player_creator.create_names
    end
  end

  describe '#new_bot_player' do
    it 'returns a bot player' do
      result = player_creator.new_bot_player
      expect(result).to be_a(Bot)
    end
  end

  describe '#new_human_player' do
    it 'returns a human player' do
      result = player_creator.new_human_player
      expect(result).to be_a(Human)
    end
  end
end
