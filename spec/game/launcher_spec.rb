#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/game/launcher'

describe Launcher do
  subject(:launcher) { described_class.new }
  let(:yaml_loader) { instance_double(YAMLLoader) }
  let(:game) { instance_double(Game) }
  let(:fen_processor) { instance_double(FenProcessor) }
  let(:board_creator) { instance_double(BoardCreator) }
  let(:player_creator) { instance_double(PlayerCreator) }

  describe '#user_wants_to_load?' do
    before { allow(launcher).to receive(:print_prompt) }

    it 'returns true when the input is y' do
      allow($stdin).to receive(:gets).and_return('y')
      result = launcher.user_wants_to_load?
      expect(result).to eq(true)
    end

    it 'returns false when the input is n' do
      allow($stdin).to receive(:gets).and_return('n')
      result = launcher.user_wants_to_load?
      expect(result).to eq(false)
    end
  end

  describe '#load_game' do
    before do
      allow(yaml_loader).to receive(:load).and_return('loaded')
      launcher.instance_variable_set(:@yaml_loader, yaml_loader)
    end

    it 'sends :message to yaml loader' do
      expect(yaml_loader).to receive(:load)
      launcher.load_game
    end

    it 'stores yaml loader return value in game' do
      launcher.load_game
      game = launcher.instance_variable_get(:@game)
      expect(game).to eq('loaded')
    end
  end

  describe '#play_game' do
    context 'when game is truthy' do
      it 'sends :play message to game' do
        launcher.instance_variable_set(:@game, game)
        expect(game).to receive(:play)
        launcher.play_game
      end
    end

    context 'when game is falsy' do
      it 'calls play default game' do
        expect(launcher).to receive(:play_default_game)
        launcher.play_game
      end
    end
  end

  describe '#load_fen' do
    context 'when cli fen is falsy' do
      before do
        allow(launcher).to receive(:cli_fen).and_return(nil)
        allow(launcher).to receive(:default_fen).and_return('default')
      end

      it 'sets default fen to fen' do
        launcher.load_fen
        fen = launcher.instance_variable_get(:@fen)
        expect(fen).to eq('default')
      end
    end

    context 'when cli fen is truthy' do
      before { allow(launcher).to receive(:cli_fen).and_return('cli fen') }

      it 'sets cli fen to fen' do
        launcher.load_fen
        fen = launcher.instance_variable_get(:@fen)
        expect(fen).to eq('cli fen')
      end
    end
  end

  describe '#cli_fen' do
    before {allow(launcher).to receive(:print_info)}

    context 'when cli arg is empty' do
      before { stub_const('Launcher::ARGV', []) }

      it 'returns nil' do
        result = launcher.cli_fen
        expect(result).to be_nil
      end
    end

    context 'when cli arg is not empty' do
      before { stub_const('Launcher::ARGV', %w[hey]) }

      it 'returns joined string' do
        result = launcher.cli_fen
        expect(result).to eq('hey')
      end
    end
  end

  describe '#create_data_from_fen' do
    before do
      allow(fen_processor).to receive(:pieces)
      allow(fen_processor).to receive(:current_color)
      allow(fen_processor).to receive(:meta_data)
      launcher.instance_variable_set(:@fen_processor, fen_processor)
    end

    it 'sends :process message to fen processor' do
      expect(fen_processor).to receive(:process)
      launcher.create_data_from_fen
    end
  end

  describe '#create_board' do
    before { launcher.instance_variable_set(:@board_creator, board_creator) }

    it 'sends :create_board message to board_creator' do
      expect(board_creator).to receive(:create_board)
      launcher.create_board
    end
  end

  describe '#create_board_operator' do
    it 'sends :new messge to board operator class' do
      expect(BoardOperator).to receive(:new)
      launcher.create_board_operator
    end
  end

  describe '#create_players' do
    before do
      launcher.instance_variable_set(:@player_creator, player_creator)
      allow(launcher).to receive(:rotate_if_needed)
    end

    it 'sends :create players message to player creator' do
      launcher.instance_variable_set(:@current_color, 'white')
      expect(player_creator).to receive(:create_players)
      launcher.create_players
    end
  end

  describe '#rotate_if_needed' do
    before do
      launcher.instance_variable_set(:@players, [])
    end

    context 'when color is black' do
      before { launcher.instance_variable_set(:@current_color, 'black') }

      it 'sends :rotate! message to players' do
        players = launcher.instance_variable_get(:@players)
        expect(players).to receive(:rotate!)
        launcher.rotate_if_needed
      end
    end

    context 'when color is white' do
      before { launcher.instance_variable_set(:@current_color, 'white') }

      it 'not sends :rotate! message to players' do
        players = launcher.instance_variable_get(:@players)
        expect(players).not_to receive(:rotate!)
        launcher.rotate_if_needed
      end
    end
  end

  describe '#lauch_game' do
    before { allow(game).to receive(:play) }

    it 'sends :new message to game class' do
      expect(Game).to receive(:new).and_return(game)
      launcher.launch_game
    end

    it 'sends :play message to game' do
      allow(Game).to receive(:new).and_return(game)
      expect(game).to receive(:play)
      launcher.launch_game
    end
  end
end
