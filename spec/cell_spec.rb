#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/cell'

describe Cell do
  describe '#create_connections' do
    subject(:cell) { described_class.new }

    context 'when creating connections for f6' do
      let(:row) { 6 }
      let(:column) { 'f' }

      it 'creates row connections' do
        cell.create_connections(row, column)
        row_right = :g6
        row_left = :e6
        expected_result = [row_right, row_left]
        result = [cell.row_right, cell.row_left]
        expect(result).to eq(expected_result)
      end

      it 'creates column connections' do
        cell.create_connections(row, column)
        column_above = :f7
        column_below = :f5
        expected_result = [column_above, column_below]
        result = [cell.column_above, cell.column_below]
        expect(result).to eq(expected_result)
      end

      it 'creates diagonal connections' do
        cell.create_connections(row, column)
        top_left_diagonal = :e7
        top_right_diagonal = :g7
        bottom_right_diagonal = :g5
        bottom_left_diagonal = :e5
        expected_result = [top_left_diagonal, top_right_diagonal, bottom_right_diagonal, bottom_left_diagonal]
        result = [cell.top_left_diagonal, cell.top_right_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal]
        expect(result).to eq(expected_result)
      end
    end

    context 'when creating connections for a1' do
      let(:row) { 1 }
      let(:column) { 'a' }

      it 'creates row connections' do
        cell.create_connections(row, column)
        row_right = :b1
        row_left = nil
        expected_result = [row_right, row_left]
        result = [cell.row_right, cell.row_left]
        expect(result).to eq(expected_result)
      end

      it 'creates column connections' do
        cell.create_connections(row, column)
        column_above = :a2
        column_below = nil
        expected_result = [column_above, column_below]
        result = [cell.column_above, cell.column_below]
        expect(result).to eq(expected_result)
      end

      it 'creates diagonal connections' do
        cell.create_connections(row, column)
        top_left_diagonal = nil
        top_right_diagonal = :b2
        bottom_right_diagonal = nil
        bottom_left_diagonal = nil
        expected_result = [top_left_diagonal, top_right_diagonal, bottom_right_diagonal, bottom_left_diagonal]
        result = [cell.top_left_diagonal, cell.top_right_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal]
        expect(result).to eq(expected_result)
      end
    end

    context 'when creating connections for e7' do
      let(:row) { 7 }
      let(:column) { 'e' }

      it 'creates row connections' do
        cell.create_connections(row, column)
        row_right = :f7
        row_left = :d7
        expected_result = [row_right, row_left]
        result = [cell.row_right, cell.row_left]
        expect(result).to eq(expected_result)
      end

      it 'creates column connections' do
        cell.create_connections(row, column)
        column_above = :e8
        column_below = :e6
        expected_result = [column_above, column_below]
        result = [cell.column_above, cell.column_below]
        expect(result).to eq(expected_result)
      end

      it 'creates diagonal connections' do
        cell.create_connections(row, column)
        top_left_diagonal = :d8
        top_right_diagonal = :f8
        bottom_right_diagonal = :f6
        bottom_left_diagonal = :d6
        expected_result = [top_left_diagonal, top_right_diagonal, bottom_right_diagonal, bottom_left_diagonal]
        result = [cell.top_left_diagonal, cell.top_right_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal]
        expect(result).to eq(expected_result)
      end
    end
  end
end
