#!/usr/bin/env ruby
# frozen_string_literal: true

# Moves Generator Module
module MovesGenerator
  private

  def move_methods(piece_name)
    {
      r: %i[horizontal_moves vertical_moves],
      n: [:knight_moves],
      b: [:diagonal_moves],
      q: %i[horizontal_moves diagonal_moves vertical_moves],
      k: [:king_moves],
      p: [:pawn_moves]
    }[piece_name.downcase.to_sym]
  end

  def diagonal_moves(cell)
    generate_moves_from_directions(%i[top_left_diagonal
                                      top_right_diagonal
                                      bottom_right_diagonal
                                      bottom_left_diagonal],
                                   cell)
  end

  def horizontal_moves(cell)
    generate_moves_from_directions(%i[row_right row_left], cell)
  end

  def vertical_moves(cell)
    generate_moves_from_directions(%i[column_above column_below], cell)
  end

  def knight_moves(cell, moves = [])
    first_steps = %i[column_above row_right column_below row_left]
    second_steps = %i[top_left_diagonal top_right_diagonal bottom_right_diagonal bottom_left_diagonal]

    first_steps.each do |first_step|
      current_cell = @board[cell].send(first_step)
      second_steps_for_this_first_step = second_steps[0..1]
      second_steps << second_steps.shift
      next if current_cell.nil?

      moves += generate_moves_from_possible_steps(second_steps_for_this_first_step, current_cell)
    end
    moves
  end

  def king_moves(cell)
    steps_possible = %i[row_right
                        row_left
                        column_above
                        column_below
                        top_left_diagonal
                        top_right_diagonal
                        bottom_right_diagonal
                        bottom_left_diagonal]
    generate_moves_from_possible_steps(steps_possible, cell)
  end

  def pawn_moves(cell)
    return white_pawn_moves(cell) if @board[cell].piece.color == 'white'

    black_pawn_moves(cell) if @board[cell].piece.color == 'black'
  end

  def white_pawn_moves(cell)
    moves = generate_moves_from_possible_steps(%i[column_above top_left_diagonal top_right_diagonal], cell)
    moves += add_double_step(cell, :column_above) if cell.match?(/^[a-h]2$/)
    moves
  end

  def black_pawn_moves(cell)
    moves = generate_moves_from_possible_steps(%i[column_below bottom_left_diagonal bottom_right_diagonal], cell)
    moves += add_double_step(cell, :column_below) if cell.match?(/^[a-h]7$/)
    moves
  end

  def add_double_step(cell, step)
    step1 = @board[cell].send(step)
    step2 = @board[step1].send(step) if !step1.nil? && @board[step1].piece.nil?
    step2 ? [step2] : []
  end

  def generate_moves_from_directions(directions, cell, moves = [])
    directions.each do |direction|
      moves += generate_moves_recursively(@board[cell].send(direction), direction) if @board[cell].send(direction)
    end
    moves
  end

  def generate_moves_from_possible_steps(steps_possible, cell, moves = [])
    steps_possible.each do |step|
      step = @board[cell].send(step)
      moves << step unless step.nil?
    end
    moves
  end

  def generate_moves_recursively(cell, direction, moves = [])
    if @board[cell].send(direction).nil? || !@board[cell].piece.nil?
      moves << cell
      return moves
    end

    moves << cell
    next_cell = @board[cell].send(direction)
    generate_moves_recursively(next_cell, direction, moves)
  end
end
