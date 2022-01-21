#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/players/components/mode-chooser'

describe ModeChooser do
  subject(:mode_chooser) { described_class.new }

  before do
    allow(mode_chooser).to receive(:print_error)
    allow(mode_chooser).to receive(:print_info)
    allow(mode_chooser).to receive(:accent)
  end

  describe '#choose_mode' do
    context 'when user enters a valid mode' do
      before do
        valid_mode = 'a'
        allow(mode_chooser).to receive(:print)
        allow(mode_chooser).to receive(:mode_input).and_return(valid_mode)
      end

      it 'calls mode_input once' do
        expect(mode_chooser).to receive(:mode_input).once
        mode_chooser.choose_mode
      end
    end

    context 'when user enters an invalid mode once than a valid mode' do
      before do
        invalid_mode = 'ab'
        valid_mode = 'a'
        allow(mode_chooser).to receive(:print)
        allow(mode_chooser).to receive(:mode_input).and_return(invalid_mode, valid_mode)
      end

      it 'calls mode_input twice' do
        expect(mode_chooser).to receive(:mode_input).twice
        mode_chooser.choose_mode
      end
    end

    context 'when user enters an invalid mode twice than a valid mode' do
      before do
        invalid_mode1 = 'ab'
        invalid_mode2 = ''
        valid_mode = 'a'
        allow(mode_chooser).to receive(:print)
        allow(mode_chooser).to receive(:mode_input).and_return(invalid_mode1, invalid_mode2, valid_mode)
      end

      it 'calls mode_input three times' do
        expect(mode_chooser).to receive(:mode_input).exactly(3).times
        mode_chooser.choose_mode
      end
    end
  end
end
