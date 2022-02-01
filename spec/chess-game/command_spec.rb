#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/chess-game/command'
require_relative '../../lib/players/human'

describe Command do
  subject(:command) { described_class.new }
  let(:player) { double('Player') }
  let(:game) { double('Game') }
  let(:result) { double('Result') }

  describe '#propose_draw' do
    context 'when draw proposal status is false' do
      before do
        command.instance_variable_set(:@draw_proposal_status, false)
      end

      it 'doesn\'t call draw_prompt' do
        expect(command).not_to receive(:draw_prompt)
        command.propose_draw(player)
      end
    end

    context 'when draw proposal status is true' do
      before do
        command.instance_variable_set(:@draw_proposal_status, true)
        allow(command).to receive(:update_draw_approval_status)
        allow(command).to receive(:update_draw_proposal_status)
        allow(command).to receive(:player_choice_for_draw_approval)
      end

      it 'calls draw_prompt' do
        expect(command).to receive(:draw_prompt)
        command.propose_draw(player)
      end
    end
  end

  describe '#player_choice_for_draw_approval' do
    before do
      allow(player).to receive(:is_a?).with(Human).and_return(true)
    end

    context 'when the player is human' do
      it 'asks for input' do
        expect(command).to receive(:gets).and_return('y/n')
        command.player_choice_for_draw_approval(player)
      end
    end

    context 'when the player is not a human' do
      before do
        allow(player).to receive(:is_a?).with(Human).and_return(false)
      end

      it 'returns y or n' do
        result = command.player_choice_for_draw_approval(player)
        expect(%w[y n].include?(result)).to eq(true)
      end
    end
  end

  describe '#update_draw_approval_status' do
    context 'when choice is y' do
      it 'updates draw approval status to true' do
        command.update_draw_approval_status('y')
        result = command.instance_variable_get(:@draw_approval_status)
        expect(result).to eq(true)
      end
    end

    context 'when choice is n' do
      it 'updates draw approval status to false' do
        command.update_draw_approval_status('n')
        result = command.instance_variable_get(:@draw_approval_status)
        expect(result).to eq(false)
      end
    end
  end

  describe '#update_draw_proposal_status' do
    it 'update the draw proposal status with the given value' do
      value = false
      command.update_draw_proposal_status(value)
      result = command.instance_variable_get(:@draw_proposal_status)
      expect(result).to eq(value)
    end
  end

  describe '#execute_command' do
    before do
      allow(command).to receive(:print_command_prompt)
      allow(command).to receive(:print_spacing)
    end

    context 'when the case is exit' do
      before do
        allow(command).to receive(:gets).and_return('exit')
      end

      it 'breaks immediately' do
        expect(command).not_to receive(:print_spacing)
        command.execute_command(game, result)
      end
    end

    context 'when the case is draw' do
      before do
        allow(command).to receive(:gets).and_return('draw', 'exit')
      end

      it 'calls create_draw_proposal' do
        expect(command).to receive(:create_draw_proposal)
        command.execute_command(game, result)
      end
    end

    context 'when the case is resign' do
      before do
        allow(command).to receive(:gets).and_return('resign', 'exit')
      end

      it 'calls resign' do
        expect(command).to receive(:resign).with(result, game)
        command.execute_command(game, result)
      end
    end

    context 'when the case is save' do
      before do
        allow(command).to receive(:gets).and_return('save', 'exit')
      end

      it 'calls save' do
        expect(command).to receive(:save).with(game)
        command.execute_command(game, result)
      end
    end
  end

  describe '#resign' do
    before do
      allow(result).to receive(:update_resign)
      allow(result).to receive(:announce)
      allow(command).to receive(:exit)
    end

    it 'sends :update_resign message to result' do
      expect(result).to receive(:update_resign).with(true)
      command.resign(result, game)
    end

    it 'sends :announce message to result' do
      expect(result).to receive(:announce).with(game)
      command.resign(result, game)
    end
  end
end
