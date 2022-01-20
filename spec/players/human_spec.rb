#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/human'

describe Human do
  subject(:human) { described_class.new }

  before do
    allow(human).to receive(:print_error)
  end

  describe '#make_choice' do
    let(:cell_choice_maker) { human.instance_variable_get(:@cell_choice_maker) }

    context 'when the user enters the valid choice' do
      before do
        valid_choice = 'a1'
        allow(cell_choice_maker).to receive(:human_choice).and_return(valid_choice)
      end

      it 'sends message human_choice to cell_choice_maker once' do
        expect(cell_choice_maker).to receive(:human_choice).once
        human.make_choice
      end
    end

    context 'when the user enters invalid choice once then the valid choice' do
      before do
        invalid_choice = 'a'
        valid_choice = 'a1'
        allow(cell_choice_maker).to receive(:human_choice).and_return(invalid_choice, valid_choice)
      end

      it 'sends message human_choice to cell_choice_maker twice' do
        expect(cell_choice_maker).to receive(:human_choice).twice
        human.make_choice
      end
    end

    context 'when the user enters invalid choice twice then the valid choice' do
      before do
        invalid_choice1 = ''
        invalid_choice2 = ''
        valid_choice = 'a1'
        allow(cell_choice_maker).to receive(:human_choice).and_return(invalid_choice1, invalid_choice2, valid_choice)
      end

      it 'sends message human_choice to cell_choice_maker three times' do
        expect(cell_choice_maker).to receive(:human_choice).exactly(3).times
        human.make_choice
      end
    end
  end

  describe '#create_name' do
    let(:name_creator) { human.instance_variable_get(:@name_creator) }

    context 'when the user enters the valid name' do
      before do
        valid_name = 'a1'
        allow(name_creator).to receive(:human_name).and_return(valid_name)
      end

      it 'sends message human_name to name_creator once' do
        expect(name_creator).to receive(:human_name).once
        human.create_name
      end
    end

    context 'when the user enters invalid name once and then the valid name' do
      before do
        invalid_name = ''
        valid_name = 'a1'
        allow(name_creator).to receive(:human_name).and_return(invalid_name, valid_name)
      end

      it 'sends message human_name to name_creator once' do
        expect(name_creator).to receive(:human_name).twice
        human.create_name
      end
    end

    context 'when the user enters invalid name twice and then the valid name' do
      before do
        invalid_name1 = ''
        invalid_name2 = 'abcdefghijklmnopqrstuvwxyz'
        valid_name = 'a1'
        allow(name_creator).to receive(:human_name).and_return(invalid_name1, invalid_name2, valid_name)
      end

      it 'sends message human_name to name_creator once' do
        expect(name_creator).to receive(:human_name).exactly(3).times
        human.create_name
      end
    end
  end
end
