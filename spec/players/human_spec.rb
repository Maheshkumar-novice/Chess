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

  describe '#create_name' do
    it 'returns a string of size between 1 and 15' do
      allow(human).to receive(:print)
      allow(human).to receive(:gets).and_return('hello')
      human.create_name
      result = human.name.size.between?(1, 15)
      expect(result).to eq true
    end
  end
end
