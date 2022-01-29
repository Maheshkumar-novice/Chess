#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/components/creators/mode-creator'

describe ModeCreator do
  subject(:mode_creator) { described_class.new }

  before do
    allow(mode_creator).to receive(:print_error)
    allow(mode_creator).to receive(:print_info)
  end

  describe '#choose_mode' do
    context 'when user enters a valid mode' do
      before do
        valid_mode = 'a'
        allow(mode_creator).to receive(:mode_input).and_return(valid_mode)
      end

      it 'calls mode_input once' do
        expect(mode_creator).to receive(:mode_input).once
        mode_creator.choose_mode
      end

      it 'returns the valid mode' do
        result = mode_creator.choose_mode
        expect(result).to eq('a')
      end
    end

    context 'when user enters an invalid mode once than a valid mode' do
      before do
        invalid_mode = 'ab'
        valid_mode = 'a'
        allow(mode_creator).to receive(:mode_input).and_return(invalid_mode, valid_mode)
      end

      it 'calls mode_input twice' do
        expect(mode_creator).to receive(:mode_input).twice
        mode_creator.choose_mode
      end

      it 'returns the valid mode' do
        result = mode_creator.choose_mode
        expect(result).to eq('a')
      end
    end

    context 'when user enters an invalid mode twice than a valid mode' do
      before do
        invalid_mode1 = 'ab'
        invalid_mode2 = ''
        valid_mode = 'a'
        allow(mode_creator).to receive(:mode_input).and_return(invalid_mode1, invalid_mode2, valid_mode)
      end

      it 'calls mode_input three times' do
        expect(mode_creator).to receive(:mode_input).exactly(3).times
        mode_creator.choose_mode
      end

      it 'returns the valid mode' do
        result = mode_creator.choose_mode
        expect(result).to eq('a')
      end
    end
  end

  describe '#valid_mode?' do
    context 'for invalid mode' do
      before { mode_creator.instance_variable_set(:@mode, 'bs') }

      it 'returns false' do
        result = mode_creator.valid_mode?
        expect(result).to eq(false)
      end
    end

    context 'for valid mode' do
      before { mode_creator.instance_variable_set(:@mode, 'a') }

      it 'returns true' do
        result = mode_creator.valid_mode?
        expect(result).to eq(true)
      end
    end
  end
end
