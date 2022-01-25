#!/usr/bin/env ruby
# frozen_string_literal: true

require 'forwardable'

# Chess board - Cell
class Cell
  extend Forwardable

  def_delegators :piece, :create_moves, :classify_moves, :in_check?
  def_delegator :piece, :current_cell=, :update_current_cell_of_piece

  attr_accessor :piece,
                :row_right,
                :row_left,
                :column_above,
                :column_below,
                :top_left_diagonal,
                :top_right_diagonal,
                :bottom_right_diagonal,
                :bottom_left_diagonal

  def create_connections(row, column)
    create_row_connections(row, column)
    create_column_connections(row, column)
    create_diagonal_connections(row, column)
  end

  def diagonals
    [top_right_diagonal, top_left_diagonal, bottom_right_diagonal, bottom_left_diagonal]
  end

  def update_current_cell_of_piece(cell_marker)
    piece.current_cell = cell_marker
  end

  def update_piece_to(piece)
    self.piece = piece
  end

  def color?(color)
    piece&.color?(color)
  end

  def piece_name
    piece&.name
  end

  def piece_color
    piece&.color
  end

  def empty?
    piece.nil?
  end

  def occupied?
    !empty?
  end

  def to_s
    piece&.unicode
  end

  private

  def create_row_connections(row, column)
    self.row_right = create_row_right_connection(row, column)
    self.row_left = create_row_left_connection(row, column)
  end

  def create_column_connections(row, column)
    self.column_above = create_column_above_connection(row, column)
    self.column_below = create_column_below_connection(row, column)
  end

  def create_diagonal_connections(row, column)
    self.top_left_diagonal = create_top_left_connection(row, column)
    self.top_right_diagonal = create_top_right_connection(row, column)
    self.bottom_right_diagonal = create_bottom_right_connection(row, column)
    self.bottom_left_diagonal = create_bottom_left_connection(row, column)
  end

  def create_column_above_connection(row, column)
    return if row == 8

    (column + (row + 1).to_s).to_sym
  end

  def create_row_right_connection(row, column)
    return if column == 'h'

    (column.next + row.to_s).to_sym
  end

  def create_row_left_connection(row, column)
    return if column == 'a'

    ((column.ord - 1).chr + row.to_s).to_sym
  end

  def create_column_below_connection(row, column)
    return if row == 1

    (column + (row - 1).to_s).to_sym
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
