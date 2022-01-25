#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../board/cell'

# Cell Creator
class CellCreator
  def create_cell(row, column, piece)
    cell = Cell.new
    cell.piece = piece
    cell.create_connections(row, column)
    cell
  end

  def cell_marker(row, column)
    (column + row.to_s).to_sym
  end
end
