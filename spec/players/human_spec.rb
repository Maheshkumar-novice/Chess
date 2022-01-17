#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/players/human'

describe Human do
  subject(:human) { described_class.new }

  describe '#input' do
    it 'returns a string' do
      allow(human).to receive(:gets).and_return("aa\n")
      result = human.input
      expected_result = 'aa'
      expect(result).to eq(expected_result)
    end
  end
end
