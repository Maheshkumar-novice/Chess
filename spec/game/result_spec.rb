#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/game/result'

describe Result do
  subject(:result) { described_class.new }
  let(:game) { double('Game') }

  describe '#update_manual_draw' do
    it 'updates the value of draw with the given value' do
      value = true
      result.update_manual_draw(value)
      current = result.instance_variable_get(:@manual_draw)
      expect(current).to eq(value)
    end
  end

  describe '#update_fifty_move_rule_draw' do
    it 'updates the value of draw with the given value' do
      value = true
      result.update_fifty_move_rule_draw(value)
      current = result.instance_variable_get(:@fifty_move_rule_draw)
      expect(current).to eq(value)
    end
  end

  describe '#update_checkmate' do
    it 'updates the value of checkmate with the given value' do
      value = true
      result.update_checkmate(value)
      current = result.instance_variable_get(:@checkmate)
      expect(current).to eq(value)
    end
  end

  describe '#update_stalemate' do
    it 'updates the value of stalemate with the given value' do
      value = true
      result.update_stalemate(value)
      current = result.instance_variable_get(:@stalemate)
      expect(current).to eq(value)
    end
  end

  describe '#update_resign' do
    it 'updates the value of resign with the given value' do
      value = true
      result.update_resign(value)
      current = result.instance_variable_get(:@resign)
      expect(current).to eq(value)
    end
  end

  describe '#any?' do
    context 'when manual_draw is true' do
      it 'returns true' do
        result.instance_variable_set(:@manual_draw, true)
        expect(result.any?).to eq(true)
      end
    end

    context 'when fifty_move_rule_draw is true' do
      it 'returns true' do
        result.instance_variable_set(:@fifty_move_rule_draw, true)
        expect(result.any?).to eq(true)
      end
    end

    context 'when checkmate is true' do
      it 'returns true' do
        result.instance_variable_set(:@checkmate, true)
        expect(result.any?).to eq(true)
      end
    end

    context 'when stalemate is true' do
      it 'returns true' do
        result.instance_variable_set(:@stalemate, true)
        expect(result.any?).to eq(true)
      end
    end

    context 'when resign is true' do
      it 'returns true' do
        result.instance_variable_set(:@resign, true)
        expect(result.any?).to eq(true)
      end
    end

    context 'when no result is true' do
      it 'returns false' do
        expect(result.any?).to eq(false)
      end
    end
  end

  describe '#announce' do
    context 'when manual_draw is true' do
      it 'calls announce_draw' do
        result.instance_variable_set(:@manual_draw, true)
        expect(result).to receive(:announce_draw)
        result.announce(game)
      end
    end

    context 'when fifty_move_rule_draw is true' do
      it 'calls announce_draw' do
        result.instance_variable_set(:@fifty_move_rule_draw, true)
        expect(result).to receive(:announce_fifty_move_rule_draw)
        result.announce(game)
      end
    end

    context 'when checkmate is true' do
      it 'calls announce_checkmate' do
        result.instance_variable_set(:@checkmate, true)
        expect(result).to receive(:announce_checkmate).with(game)
        result.announce(game)
      end
    end

    context 'when stalemate is true' do
      it 'calls announce_stalemate' do
        result.instance_variable_set(:@stalemate, true)
        expect(result).to receive(:announce_stalemate)
        result.announce(game)
      end
    end

    context 'when resign is true' do
      it 'calls announce_player_resignation' do
        result.instance_variable_set(:@resign, true)
        expect(result).to receive(:announce_player_resignation).with(game)
        result.announce(game)
      end
    end
  end
end
