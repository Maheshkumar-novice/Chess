#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/cell/utils/cell-creator'

describe CellCreator do
  subject(:cell_creator) { described_class.new }
  let(:piece) { double('Piece') }

  describe '#create_cell' do
    it 'returns a cell object' do
      row = 3
      column = 'a'
      cell = cell_creator.create_cell(row, column, piece)
      expect(cell).to be_a(Cell)
    end
  end

  describe '#cell_marker' do
    it 'returns a symbol' do
      row = 7
      column = 'h'
      result = cell_creator.cell_marker(row, column)
      expect(result).to be_a(Symbol)
    end

    it 'returns a valid marker' do
      row = 7
      column = 'h'
      result = cell_creator.cell_marker(row, column)
      expect(result).to eq(:h7)
    end
  end
end
