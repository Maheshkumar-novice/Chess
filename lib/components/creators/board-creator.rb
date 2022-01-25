#!/usr/bin/env ruby
# frozen_string_literal: true

# Creats chess board from pieces
class BoardCreator
  def initialize(cell_creator: CellCreator.new)
    @cell_creator = cell_creator
    @rows = (1..8).to_a.reverse
    @columns = ('a'..'h').to_a
  end

  def create_board(pieces)
    @rows.each_with_object({}) do |row, board|
      @columns.each do |column|
        cell_marker = @cell_creator.cell_marker(row, column)
        board[cell_marker] = @cell_creator.create_cell(row, column, pieces.shift)

        next if board[cell_marker].empty?

        board[cell_marker].update_current_cell_of_piece(cell_marker)
      end
    end
  end
end
