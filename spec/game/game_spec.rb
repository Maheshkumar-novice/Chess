#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/game/game'

describe Game do
  subject(:game) { described_class.new(board_operator, players, current_color, counters) }
  let(:board_operator) { double('BoardOperator') }
  let(:promotion) { double('Promotion') }
  let(:counters) { double('Counters') }
  let(:players) { [current_player, other_player] }
  let(:current_player) { double('Player') }
  let(:other_player) { double('Player') }
  let(:current_color) { 'white' }

  describe '#game_loop' do
    before do
      allow(game).to receive(:print_data)
      allow(game).to receive(:update_result)
      allow(game).to receive(:create_source_choice)
      allow(game).to receive(:create_destination_choice)
      allow(game).to receive(:update_counters)
      allow(game).to receive(:make_move)
    end

    context 'when the game is over at the first iteration' do
      before do
        allow(game).to receive(:game_over?).and_return(true)
      end

      it 'doesn\'t call make move' do
        expect(game).not_to receive(:make_move)
        game.game_loop
      end
    end

    context 'when the game is over at the second iteration' do
      before do
        allow(game).to receive(:game_over?).and_return(false, true)
      end

      it 'calls make move one time' do
        expect(game).to receive(:make_move)
        game.game_loop
      end
    end

    context 'when the game is over at the third iteration' do
      before do
        allow(game).to receive(:game_over?).and_return(false, false, true)
      end

      it 'calls make move two times' do
        expect(game).to receive(:make_move).twice
        game.game_loop
      end
    end
  end

  describe '#update_draws' do
    before do
      allow(game.instance_variable_get(:@counters)).to receive(:fifty_move_rule?)
    end

    let(:command) { game.instance_variable_get(:@command) }
    let(:result) { game.instance_variable_get(:@result) }

    it 'sends :propose_draw message to command' do
      expect(command).to receive(:propose_draw)
      game.update_draws
    end

    it 'sends :draw_approval_status message to command' do
      expect(command).to receive(:draw_approval_status)
      game.update_draws
    end

    it 'sends :update_manual_draw message to result' do
      expect(result).to receive(:update_manual_draw)
      game.update_draws
    end

    it 'sends :update_fifty_move_rule_draw message to result' do
      expect(result).to receive(:update_fifty_move_rule_draw)
      game.update_draws
    end
  end

  describe '#update_mates' do
    let(:result) { game.instance_variable_get(:@result) }

    before do
      allow(board_operator).to receive(:checkmate?)
      allow(board_operator).to receive(:stalemate?)
    end

    it 'sends :update_checkmate message to result' do
      expect(result).to receive(:update_checkmate)
      game.update_mates
    end

    it 'sends :update_stalemate message to result' do
      expect(result).to receive(:update_stalemate)
      game.update_mates
    end
  end

  describe '#game_over?' do
    let(:result) { game.instance_variable_get(:@result) }

    it 'sends :any? message to result' do
      expect(result).to receive(:any?)
      game.game_over?
    end
  end

  describe '#make_source' do
    before do
      allow(game).to receive(:source_choice_input)
      allow(game).to receive(:create_moves_for_source)
      allow(game).to receive(:human?).and_return(true)
    end

    context 'when moves are not empty' do
      before do
        not_empty = { empty: [:a1], captures: [:a2] }
        allow(game).to receive(:create_moves_for_source).and_return(not_empty)
      end

      it 'not shows error' do
        expect(game).not_to receive(:print_error)
        game.make_source
      end
    end

    context 'when moves are empty and not empty' do
      before do
        empty = { empty: [], captures: [] }
        not_empty = { empty: [:a2], captures: [] }
        allow(game).to receive(:create_moves_for_source).and_return(empty, not_empty)
      end

      it 'it shows error once' do
        expect(game).to receive(:print_error)
        game.make_source
      end
    end

    context 'when moves are empty, empty and not empty' do
      before do
        empty = { empty: [], captures: [] }
        not_empty = { empty: [:a2], captures: [] }
        allow(game).to receive(:create_moves_for_source).and_return(empty, empty, not_empty)
      end

      it 'it shows error twice' do
        expect(game).to receive(:print_error).twice
        game.make_source
      end
    end
  end

  describe '#source_choice_input' do
    before { allow(game).to receive(:human?).and_return(true) }

    context 'for command input' do
      let(:command) { game.instance_variable_get(:@command) }

      before do
        allow(current_player).to receive(:make_choice).and_return('cmd', 'a1')
        allow(game).to receive(:valid_source?).and_return(true)
      end

      it 'sends :execute message to command' do
        expect(command).to receive(:execute)
        game.source_choice_input
      end
    end

    context 'for source cell input' do
      before { allow(current_player).to receive(:make_choice).and_return('') }

      context 'when valid source choice made' do
        before do
          allow(game).to receive(:valid_source?).and_return(true)
        end

        it 'not shows error' do
          expect(game).not_to receive(:print_error)
          game.source_choice_input
        end
      end

      context 'when invalid source choice made then valid source choice made' do
        before do
          allow(game).to receive(:valid_source?).and_return(false, true)
        end

        it 'shows error once' do
          expect(game).to receive(:print_error)
          game.source_choice_input
        end
      end

      context 'when invalide source choice made twice then valid source choice made' do
        before do
          allow(game).to receive(:valid_source?).and_return(false, false, true)
        end

        it 'shows error twice' do
          expect(game).to receive(:print_error).twice
          game.source_choice_input
        end
      end
    end
  end

  describe '#make_destination' do
    before { allow(game).to receive(:human?).and_return(true) }

    context 'when valid destination choice made' do
      before do
        game.instance_variable_set(:@moves, { empty: [:a3], captures: [:a1] })
        allow(current_player).to receive(:make_choice).and_return('a1')
      end

      it 'not shows error' do
        expect(game).not_to receive(:print_error)
        game.make_destination
      end
    end

    context 'when invalid destination choice made then valid destination choice made' do
      before do
        game.instance_variable_set(:@moves, { empty: [:a3], captures: [:a2] })
        allow(current_player).to receive(:make_choice).and_return('a1', 'a2')
      end

      it 'shows error once' do
        expect(game).to receive(:print_error)
        game.make_destination
      end
    end

    context 'when invalide destination choice made twice then valid destination choice made' do
      before do
        game.instance_variable_set(:@moves, { empty: [:a3], captures: [:a4] })
        allow(current_player).to receive(:make_choice).and_return('a1', 'a2', 'a3')
      end

      it 'shows error twice' do
        expect(game).to receive(:print_error).twice
        game.make_destination
      end
    end
  end

  describe '#update_counters' do
    before do
      allow(game.instance_variable_get(:@counters)).to receive(:update_counters)
      allow(board_operator).to receive(:board)
    end

    it 'sends update_counters message to counters' do
      expect(game.instance_variable_get(:@counters)).to receive(:update_counters)
      game.update_counters
    end
  end

  describe '#make_move' do
    before do
      allow(game).to receive(:promotion)
      allow(game).to receive(:switch_current_color)
      allow(game).to receive(:switch_players)
      allow(game).to receive(:update_moves_for_post_move_print)
    end

    it 'sends :make_move message to board_operator' do
      expect(board_operator).to receive(:make_move)
      game.make_move
    end
  end

  describe '#promotion' do
    before do
      game.instance_variable_set(:@promotion, promotion)
      allow(board_operator).to receive(:board)
    end

    context 'when promotion available' do
      before { allow(game).to receive(:promotion?).and_return(true) }

      it 'sends promote message to promotion' do
        expect(promotion).to receive(:promote)
        game.promotion
      end
    end

    context 'when promotion not available' do
      before { allow(game).to receive(:promotion?).and_return(false) }

      it 'doesn\'t send promote message to promotion' do
        expect(promotion).not_to receive(:promote)
        game.promotion
      end
    end
  end

  describe '#switch_current_color' do
    it 'switches color' do
      previous_color = game.instance_variable_get(:@current_color)
      game.switch_current_color
      current_color = game.instance_variable_get(:@current_color)
      expect(current_color).not_to eq(previous_color)
    end
  end

  describe '#switch_players' do
    it 'switches players' do
      current_player = game.instance_variable_get(:@current_player)
      other_player = game.instance_variable_get(:@other_player)
      players = [current_player, other_player]
      game.switch_players
      current_player = game.instance_variable_get(:@current_player)
      other_player = game.instance_variable_get(:@other_player)
      current_players = [current_player, other_player]
      expect(current_players).to eq(players.reverse)
    end
  end

  describe '#announce_result' do
    let(:result) { game.instance_variable_get(:@result) }

    it 'sends :announce message to result' do
      expect(result).to receive(:announce)
      game.announce_result
    end
  end
end
