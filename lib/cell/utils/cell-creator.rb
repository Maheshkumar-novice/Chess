#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../cell'

# Creates board cell
class CellCreator
  def create_cell(row, column, piece)
    cell = Cell.new
    cell.update_piece_to(piece)
    cell.create_connections(row, column)
    cell
  end

  def cell_marker(row, column)
    (column + row.to_s).to_sym
  end
end
