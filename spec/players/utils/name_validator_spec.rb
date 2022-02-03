#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/players/utils/name-validator'

describe NameValidator do
  subject(:name_validator) { described_class.new }

  describe '#valid?' do
    context 'when the given name is an empty string' do
      it 'returns false' do
        name = ''
        result = name_validator.valid?(name)
        expect(result).to eq false
      end
    end

    context 'when the given name is of length greater than max_name_length' do
      it 'returns false' do
        max_name_length = name_validator.instance_variable_get(:@max_name_length)
        name = 'a' * (max_name_length + 5)
        result = name_validator.valid?(name)
        expect(result).to eq false
      end
    end

    context 'when the given name is valid' do
      it 'returns true' do
        name = 'bot name'
        result = name_validator.valid?(name)
        expect(result).to eq true
      end
    end
  end
end
