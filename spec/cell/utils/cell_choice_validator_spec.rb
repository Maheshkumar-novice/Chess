#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/cell/utils/cell-choice-validator'

describe CellChoiceValidator do
  subject(:cell_choice_validator) { described_class.new }

  describe '#valid?' do
    context 'when the given choice is an empty string' do
      it 'returns false' do
        choice = ''
        result = cell_choice_validator.valid?(choice)
        expect(result).to eq false
      end
    end

    context 'when the given choice is of length greater than 2' do
      it 'returns false' do
        choice = 'a21'
        result = cell_choice_validator.valid?(choice)
        expect(result).to eq false
      end
    end

    context 'when the given choice is valid' do
      it 'returns true' do
        choice = 'b1'
        result = cell_choice_validator.valid?(choice)
        expect(result).to eq true
      end
    end
  end
end
