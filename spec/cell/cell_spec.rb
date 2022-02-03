#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/cell/cell'

describe Cell do
  subject(:cell) { described_class.new }
  let(:piece) { double('Piece') }

  describe '#create_connections' do
    context 'for right edge cell' do
      before { cell.create_connections(3, 'h') }

      it 'creates row connections' do
        result = [cell.row_left, cell.row_right]
        expected_result = [:g3, nil]
        expect(result).to eq(expected_result)
      end

      it 'creates column connections' do
        result = [cell.column_above, cell.column_below]
        expected_result = %i[h4 h2]
        expect(result).to eq(expected_result)
      end

      it 'creates diagonal connections' do
        result = [cell.top_left_diagonal, cell.top_right_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal]
        expected_result = [:g4, nil, nil, :g2]
        expect(result).to eq(expected_result)
      end
    end

    context 'for left edge cell' do
      before { cell.create_connections(5, 'a') }

      it 'creates row connections' do
        result = [cell.row_left, cell.row_right]
        expected_result = [nil, :b5]
        expect(result).to eq(expected_result)
      end

      it 'creates column connections' do
        result = [cell.column_above, cell.column_below]
        expected_result = %i[a6 a4]
        expect(result).to eq(expected_result)
      end

      it 'creates diagonal connections' do
        result = [cell.top_left_diagonal, cell.top_right_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal]
        expected_result = [nil, :b6, :b4, nil]
        expect(result).to eq(expected_result)
      end
    end

    context 'for right corner cell' do
      before { cell.create_connections(8, 'h') }

      it 'creates row connections' do
        result = [cell.row_left, cell.row_right]
        expected_result = [:g8, nil]
        expect(result).to eq(expected_result)
      end

      it 'creates column connections' do
        result = [cell.column_above, cell.column_below]
        expected_result = [nil, :h7]
        expect(result).to eq(expected_result)
      end

      it 'creates diagonal connections' do
        result = [cell.top_left_diagonal, cell.top_right_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal]
        expected_result = [nil, nil, nil, :g7]
        expect(result).to eq(expected_result)
      end
    end

    context 'for left corner cell' do
      before { cell.create_connections(1, 'a') }

      it 'creates row connections' do
        result = [cell.row_left, cell.row_right]
        expected_result = [nil, :b1]
        expect(result).to eq(expected_result)
      end

      it 'creates column connections' do
        result = [cell.column_above, cell.column_below]
        expected_result = [:a2, nil]
        expect(result).to eq(expected_result)
      end

      it 'creates diagonal connections' do
        result = [cell.top_left_diagonal, cell.top_right_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal]
        expected_result = [nil, :b2, nil, nil]
        expect(result).to eq(expected_result)
      end
    end

    context 'for middle cell' do
      before { cell.create_connections(4, 'd') }

      it 'creates row connections' do
        result = [cell.row_left, cell.row_right]
        expected_result = %i[c4 e4]
        expect(result).to eq(expected_result)
      end

      it 'creates column connections' do
        result = [cell.column_above, cell.column_below]
        expected_result = %i[d5 d3]
        expect(result).to eq(expected_result)
      end

      it 'creates diagonal connections' do
        result = [cell.top_left_diagonal, cell.top_right_diagonal, cell.bottom_right_diagonal, cell.bottom_left_diagonal]
        expected_result = %i[c5 e5 e3 c3]
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#diagonals' do
    before { cell.create_connections(3, 'h') }

    it 'returns 4 diagonals' do
      result = cell.diagonals.size
      expect(result).to eq(4)
    end

    it 'returns correct diagonals' do
      result = cell.diagonals
      expected_result = [:g4, nil, nil, :g2]
      expect(result).to eq(expected_result)
    end
  end

  describe '#update_piece_to' do
    it 'updates the piece' do
      cell.update_piece_to(piece)
      expect(cell.piece).to eq(piece)
    end
  end

  describe '#piece_name' do
    context 'when piece is set' do
      before do
        allow(piece).to receive(:name).and_return('rick')
        cell.piece = piece
      end

      it 'sends :name message to piece' do
        expect(piece).to receive(:name)
        cell.piece_name
      end

      it 'returns the return value of the message' do
        name = cell.piece_name
        expect(name).to eq('rick')
      end
    end

    context 'when piece is not set' do
      it 'returns nil' do
        name = cell.piece_name
        expect(name).to be_nil
      end
    end
  end

  describe '#piece_color' do
    context 'when piece is set' do
      before do
        allow(piece).to receive(:color).and_return('white')
        cell.piece = piece
      end

      it 'sends :color message to piece' do
        expect(piece).to receive(:color)
        cell.piece_color
      end

      it 'returns the return value of the message' do
        color = cell.piece_color
        expect(color).to eq('white')
      end
    end

    context 'when piece is not set' do
      it 'returns nil' do
        color = cell.piece_color
        expect(color).to be_nil
      end
    end
  end

  describe '#color?' do
    context 'when piece is set' do
      before do
        allow(piece).to receive(:color?).with('white').and_return(true)
        cell.piece = piece
      end

      it 'sends :color? message to piece' do
        expect(piece).to receive(:color?).with('white')
        cell.color?('white')
      end

      it 'returns the return value of the message' do
        result = cell.color?('white')
        expect(result).to eq(true)
      end
    end

    context 'when piece is not set' do
      it 'returns nil' do
        result = cell.color?('white')
        expect(result).to be_nil
      end
    end
  end

  describe '#empty?' do
    context 'when piece is set' do
      before do
        cell.piece = piece
      end

      it 'returns false' do
        result = cell.empty?
        expect(result).to eq(false)
      end
    end

    context 'when piece is not set' do
      it 'returns true' do
        result = cell.empty?
        expect(result).to eq(true)
      end
    end
  end

  describe '#occupied?' do
    context 'when piece is set' do
      before do
        cell.piece = piece
      end

      it 'returns true' do
        result = cell.occupied?
        expect(result).to eq(true)
      end
    end

    context 'when piece is not set' do
      it 'returns false' do
        result = cell.occupied?
        expect(result).to eq(false)
      end
    end
  end

  describe '#to_s' do
    context 'when piece is set' do
      before do
        allow(piece).to receive(:unicode).and_return('unicode')
        cell.piece = piece
      end

      it 'sends :unicode message to piece' do
        expect(piece).to receive(:unicode)
        cell.to_s
      end

      it 'returns the return value of the message' do
        result = cell.to_s
        expect(result).to eq('unicode')
      end
    end

    context 'when piece is not set' do
      it 'returns nil' do
        result = cell.to_s
        expect(result).to be_nil
      end
    end
  end
end
