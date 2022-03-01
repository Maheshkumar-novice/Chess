#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/game/command'
require_relative '../../lib/players/human'

describe Command do
  subject(:command) { described_class.new }
  let(:player) { double('Player') }
  let(:game) { double('Game') }
  let(:result) { double('Result') }

  describe '#propose_draw' do
    context 'when draw_proposal_status is false' do
      before do
        command.instance_variable_set(:@draw_proposal_status, false)
      end

      it 'doesn\'t update draw approval status' do
        previous_draw_approval_status = command.instance_variable_get(:@draw_approval_status)
        command.propose_draw(player, 'white')
        current_draw_approval_status = command.instance_variable_get(:@draw_approval_status)
        expect(previous_draw_approval_status).to eq(current_draw_approval_status)
      end

      it 'doesn\'t update draw proposal status' do
        previous_draw_proposal_status = command.instance_variable_get(:@draw_proposal_status)
        command.propose_draw(player, 'white')
        current_draw_proposal_status = command.instance_variable_get(:@draw_proposal_status)
        expect(previous_draw_proposal_status).to eq(current_draw_proposal_status)
      end

      it 'doesn\'t update draw proposer color' do
        previous_draw_proposer_color = command.instance_variable_get(:@draw_proposer_color)
        command.propose_draw(player, 'white')
        current_draw_proposer_color = command.instance_variable_get(:@draw_proposer_color)
        expect(previous_draw_proposer_color).to eq(current_draw_proposer_color)
      end
    end

    context 'when draw proposer color is the same as the given color' do
      let(:color) { 'white' }

      before do
        command.instance_variable_set(:@draw_proposal_status, true)
        command.instance_variable_set(:@draw_proposer_color, color)
      end

      it 'doesn\'t update draw approval status' do
        previous_draw_approval_status = command.instance_variable_get(:@draw_approval_status)
        command.propose_draw(player, color)
        current_draw_approval_status = command.instance_variable_get(:@draw_approval_status)
        expect(previous_draw_approval_status).to eq(current_draw_approval_status)
      end

      it 'doesn\'t update draw proposal status' do
        previous_draw_proposal_status = command.instance_variable_get(:@draw_proposal_status)
        command.propose_draw(player, color)
        current_draw_proposal_status = command.instance_variable_get(:@draw_proposal_status)
        expect(previous_draw_proposal_status).to eq(current_draw_proposal_status)
      end

      it 'doesn\'t update draw proposer color' do
        previous_draw_proposer_color = command.instance_variable_get(:@draw_proposer_color)
        command.propose_draw(player, color)
        current_draw_proposer_color = command.instance_variable_get(:@draw_proposer_color)
        expect(previous_draw_proposer_color).to eq(current_draw_proposer_color)
      end
    end

    context 'when draw proposal available' do
      let(:color) { 'white' }

      before do
        command.instance_variable_set(:@draw_proposal_status, true)
        command.instance_variable_set(:@draw_propose_color, 'black')
        allow(command).to receive(:player_choice_for_draw_approval).and_return('y')
        allow(command).to receive(:draw_prompt)
      end

      it 'updates draw approval status' do
        command.propose_draw(player, color)
        current_draw_approval_status = command.instance_variable_get(:@draw_approval_status)
        expect(current_draw_approval_status).to eq(true)
      end

      it 'updates draw proposal status' do
        command.propose_draw(player, color)
        current_draw_proposal_status = command.instance_variable_get(:@draw_proposal_status)
        expect(current_draw_proposal_status).to eq(false)
      end

      it 'updates draw proposer color' do
        command.propose_draw(player, color)
        current_draw_proposer_color = command.instance_variable_get(:@draw_proposer_color)
        expect(current_draw_proposer_color).to eq(nil)
      end
    end
  end

  describe '#create_draw_proposal' do
    let(:color) { 'whtie' }

    before do
      allow(game).to receive(:current_color).and_return(color)
      allow(command).to receive(:print_info)
    end

    it 'updates draw proposal status to true' do
      command.create_draw_proposal(game)
      result = command.instance_variable_get(:@draw_proposal_status)
      expect(result).to eq(true)
    end

    it 'updates draw proposer color' do
      command.create_draw_proposal(game)
      result = command.instance_variable_get(:@draw_proposer_color)
      expect(result).to eq(color)
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

  describe '#save' do
    before { allow(command).to receive(:print_file_created_message) }

    it 'sends :save message to yaml_creator' do
      yaml_creator = command.instance_variable_get(:@yaml_creator)
      expect(yaml_creator).to receive(:save).with(game)
      command.save(game)
    end
  end
end
