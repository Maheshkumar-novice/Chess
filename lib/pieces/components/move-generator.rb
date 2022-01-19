#!/usr/bin/env ruby
# frozen_string_literal: true

# Moves Generator
class MoveGenerator
  def rook_moves(cell, board)
    generate_all_moves_from_directions(%i[row_right
                                          row_left
                                          column_above
                                          column_below],
                                       cell, board)
  end

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

  def bishop_moves(cell, board)
    generate_all_moves_from_directions(%i[top_left_diagonal
                                          top_right_diagonal
                                          bottom_right_diagonal
                                          bottom_left_diagonal],
                                       cell, board)
  end

  def queen_moves(cell, board)
    generate_all_moves_from_directions(%i[top_left_diagonal
                                          top_right_diagonal
                                          bottom_right_diagonal
                                          bottom_left_diagonal
                                          row_left
                                          row_right
                                          column_above
                                          column_below],
                                       cell, board)
  end

  def king_moves(cell, board)
    generate_single_step_moves_from_directions(%i[row_right
                                                  row_left
                                                  column_above
                                                  column_below
                                                  top_left_diagonal
                                                  top_right_diagonal
                                                  bottom_right_diagonal
                                                  bottom_left_diagonal], cell, board)
  end

  def pawn_moves(cell, color, board)
    return white_pawn_moves(cell, board) if color == 'white'
    return black_pawn_moves(cell, board) if color == 'black'
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

  private

  def white_pawn_moves(cell, board)
    moves = generate_single_step_moves_from_directions(%i[column_above
                                                          top_left_diagonal
                                                          top_right_diagonal],
                                                       cell, board)
    moves += add_double_step(cell, board, :column_above) if cell.match?(/^[a-h]2$/)
    moves
  end

  def black_pawn_moves(cell, board)
    moves = generate_single_step_moves_from_directions(%i[column_below
                                                          bottom_left_diagonal
                                                          bottom_right_diagonal],
                                                       cell, board)
    moves += add_double_step(cell, board, :column_below) if cell.match?(/^[a-h]7$/)
    moves
  end

  def add_double_step(cell, board, step)
    step1 = board[cell].send(step)
    step2 = board[step1].send(step) if !step1.nil? && board[step1].piece.nil?
    step2 ? [step2] : []
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
