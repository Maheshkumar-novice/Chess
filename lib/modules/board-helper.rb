#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../cell'

# Board Helper
module BoardHelper
  private

  def reject_moves_of_same_color(moves, color)
    moves.reject do |move|
      @board[move].piece&.color == color
    end
  end

  def king_position(king_color)
    @board.each do |marker, cell|
      color = cell.piece&.color
      name = cell.piece&.name.to_s.downcase
      return marker if color == king_color && name == 'k'
    end
  end

  def create_cell_marker(row, column)
    (column + row.to_s).to_sym
  end

  def create_cell(row, column)
    cell = Cell.new
    cell.piece = @pieces.shift
    create_row_connections(row, column, cell)
    create_column_connections(row, column, cell)
    create_diagonal_connections(row, column, cell)
    cell
  end

  def create_row_connections(row, column, cell)
    cell.row_right = create_row_right_connection(row, column)
    cell.row_left = create_row_left_connection(row, column)
  end

  def create_row_right_connection(row, column)
    return if column == 'h'

    (column.next + row.to_s).to_sym
  end

  def create_row_left_connection(row, column)
    return if column == 'a'

    ((column.ord - 1).chr + row.to_s).to_sym
  end

  def create_column_connections(row, column, cell)
    cell.column_above = create_column_above_connection(row, column)
    cell.column_below = create_column_below_connection(row, column)
  end

  def create_column_above_connection(row, column)
    return if row == 8

    (column + (row + 1).to_s).to_sym
  end

  def create_column_below_connection(row, column)
    return if row == 1

    (column + (row - 1).to_s).to_sym
  end

  def create_diagonal_connections(row, column, cell)
    cell.top_left_diagonal = create_top_left_connection(row, column)
    cell.top_right_diagonal = create_top_right_connection(row, column)
    cell.bottom_right_diagonal = create_bottom_right_connection(row, column)
    cell.bottom_left_diagonal = create_bottom_left_connection(row, column)
  end

  def create_top_left_connection(row, column)
    return if row == 8 || column == 'a'

    ((column.ord - 1).chr + (row + 1).to_s).to_sym
  end

  def create_top_right_connection(row, column)
    return if row == 8 || column == 'h'

    (column.next + (row + 1).to_s).to_sym
  end

  def create_bottom_right_connection(row, column)
    return if row == 1 || column == 'h'

    (column.next + (row - 1).to_s).to_sym
  end

  def create_bottom_left_connection(row, column)
    return if row == 1 || column == 'a'

    ((column.ord - 1).chr + (row - 1).to_s).to_sym
  end
end
