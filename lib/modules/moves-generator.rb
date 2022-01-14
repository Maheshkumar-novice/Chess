#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

# Moves Generator Module
module MovesGenerator
  private

  def knight_moves(cell, board)
    first_steps = %i[column_above row_right column_below row_left]
    second_steps = %i[top_left_diagonal top_right_diagonal bottom_right_diagonal bottom_left_diagonal]

    first_steps.each_with_object([]) do |first_step, moves|
      current_cell = board[cell].send(first_step)
      second_steps_for_this_first_step = second_steps[0..1]
      second_steps << second_steps.shift
      next if current_cell.nil?

      moves.concat(generate_single_step_moves_from_directions(second_steps_for_this_first_step, current_cell, board))
    end
  end

  def generate_all_moves_from_directions(directions, cell, board, moves = [])
    directions.each do |direction|
      if board[cell].send(direction)
        moves += generate_moves_recursively(board[cell].send(direction), direction,
                                            board)
      end
    end
    moves
  end

  def generate_single_step_moves_from_directions(steps_possible, cell, board, moves = [])
    steps_possible.each do |step|
      step = board[cell].send(step)
      moves << step unless step.nil?
    end
    moves
  end

  def generate_moves_recursively(cell, direction, board, moves = [])
    if board[cell].send(direction).nil? || !board[cell].piece.nil?
      moves << cell
      return moves
    end

    moves << cell
    next_cell = board[cell].send(direction)
    generate_moves_recursively(next_cell, direction, board, moves)
  end
end
