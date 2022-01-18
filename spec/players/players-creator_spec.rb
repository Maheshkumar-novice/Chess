#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/players-creator'

describe PlayersCreator do
  subject(:players_creator) { described_class.new }

  describe '#choose_mode' do
    context 'when user enters a valid mode' do
      before do
        valid_mode = 'a'
        allow(players_creator).to receive(:print)
        allow(players_creator).to receive(:mode_input).and_return(valid_mode)
      end

      it 'calls mode_input once' do
        expect(players_creator).to receive(:mode_input).once
        players_creator.choose_mode
      end
    end

    context 'when user enters an invalid mode once than a valid mode' do
      before do
        invalid_mode = 'ab'
        valid_mode = 'a'
        allow(players_creator).to receive(:print)
        allow(players_creator).to receive(:mode_input).and_return(invalid_mode, valid_mode)
      end

      it 'calls mode_input twice' do
        expect(players_creator).to receive(:mode_input).twice
        players_creator.choose_mode
      end
    end

    context 'when user enters an invalid mode twice than a valid mode' do
      before do
        invalid_mode1 = 'ab'
        invalid_mode2 = ''
        valid_mode = 'a'
        allow(players_creator).to receive(:print)
        allow(players_creator).to receive(:mode_input).and_return(invalid_mode1, invalid_mode2, valid_mode)
      end

      it 'calls mode_input three times' do
        expect(players_creator).to receive(:mode_input).exactly(3).times
        players_creator.choose_mode
      end
    end
  end

  describe '#create_players_of_mode' do
    context 'when the mode is a' do
      before do
        players_creator.instance_variable_set(:@mode, 'a')
      end

      it 'returns first player as bot' do
        players = players_creator.create_players_of_mode
        result = players[0].is_a?(Bot)
        expect(result).to eq true
      end

      it 'returns second player as bot' do
        players = players_creator.create_players_of_mode
        result = players[1].is_a?(Bot)
        expect(result).to eq true
      end
    end

    context 'when the mode is b' do
      before do
        players_creator.instance_variable_set(:@mode, 'b')
      end

      it 'returns first player as bot' do
        players = players_creator.create_players_of_mode
        result = players[0].is_a?(Bot)
        expect(result).to eq true
      end

      it 'returns second player as human' do
        players = players_creator.create_players_of_mode
        result = players[1].is_a?(Human)
        expect(result).to eq true
      end
    end

    context 'when the mode is c' do
      before do
        players_creator.instance_variable_set(:@mode, 'c')
      end

      it 'returns first player as human' do
        players = players_creator.create_players_of_mode
        result = players[0].is_a?(Human)
        expect(result).to eq true
      end

      it 'returns second player as human' do
        players = players_creator.create_players_of_mode
        result = players[1].is_a?(Human)
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

  describe '#assign_colors' do
    before do
      players_creator.instance_variable_set(:@mode, 'b')
      players = players_creator.create_players_of_mode
      players_creator.instance_variable_set(:@players, players)
    end

    it 'adds color for the first player' do
      players = players_creator.instance_variable_get(:@players)
      players_creator.assign_colors
      expect(players[0].color).not_to be_nil
    end

    it 'adds color for the second player' do
      players = players_creator.instance_variable_get(:@players)
      players_creator.assign_colors
      expect(players[1].color).not_to be_nil
    end
  end

  describe '#create_players_hash' do
    before do
      players_creator.instance_variable_set(:@mode, 'b')
      players = players_creator.create_players_of_mode
      players_creator.instance_variable_set(:@players, players)
    end

    it 'returns a hash with key :white' do
      hash = players_creator.create_players_hash
      result = hash.include?(:white)
      expect(result).to eq true
    end

    it 'returns a hash with key :black' do
      hash = players_creator.create_players_hash
      result = hash.include?(:black)
      expect(result).to eq true
    end
  end
end
