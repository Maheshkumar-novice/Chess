#!/usr/bin/env ruby
# frozen_string_literal: true

# Chess board - Cell
class Cell
  attr_accessor :piece,
                :row_right,
                :row_left,
                :column_above,
                :column_below,
                :top_left_diagonal,
                :top_right_diagonal,
                :bottom_right_diagonal,
                :bottom_left_diagonal
end
