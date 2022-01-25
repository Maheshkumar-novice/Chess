#!/usr/bin/env ruby
# frozen_string_literal: true

# Moves Creator
class MoveCreator
  def horizontal_moves(cell, board)
    all_moves(%i[row_right row_left], cell, board)
  end

  def vertical_moves(cell, board)
    all_moves(%i[column_above column_below], cell, board)
  end

  def diagonal_moves(cell, board)
    all_moves(%i[top_left_diagonal top_right_diagonal bottom_right_diagonal bottom_left_diagonal], cell, board)
  end

  def rook_moves(cell, board)
    all_moves(%i[row_right row_left column_above column_below], cell, board)
  end

  def knight_moves(cell, board)
    first_steps = %i[column_above row_right column_below row_left]
    second_steps = %i[top_left_diagonal top_right_diagonal bottom_right_diagonal bottom_left_diagonal]

    first_steps.each_with_object([]) do |first_step, moves|
      current_cell = board[cell].send(first_step)
      second_steps_for_this_first_step = second_steps[0..1]
      second_steps << second_steps.shift
      next if current_cell.nil?

      moves.concat(single_step_moves(second_steps_for_this_first_step, current_cell, board))
    end
  end

  def bishop_moves(cell, board)
    all_moves(%i[top_left_diagonal top_right_diagonal bottom_right_diagonal bottom_left_diagonal], cell, board)
  end

  def queen_moves(cell, board)
    all_moves(
      %i[top_left_diagonal top_right_diagonal bottom_right_diagonal bottom_left_diagonal row_left row_right column_above
         column_below], cell, board
    )
  end

  def king_moves(cell, board)
    single_step_moves(
      %i[row_right row_left column_above column_below top_left_diagonal top_right_diagonal bottom_right_diagonal
         bottom_left_diagonal], cell, board
    )
  end

  def pawn_moves(cell, color, board)
    return white_pawn_moves(cell, board) if color == 'white'
    return black_pawn_moves(cell, board) if color == 'black'
  end

  private

  def white_pawn_moves(cell, board)
    moves = single_step_moves(%i[column_above top_left_diagonal top_right_diagonal], cell, board)
    moves.concat(second_step(cell, board, :column_above)) if cell.match?(/^[a-h]2$/)
    moves
  end

  def black_pawn_moves(cell, board)
    moves = single_step_moves(%i[column_below bottom_left_diagonal bottom_right_diagonal], cell, board)
    moves.concat(second_step(cell, board, :column_below)) if cell.match?(/^[a-h]7$/)
    moves
  end

  def second_step(cell, board, step)
    step1 = board[cell].send(step)
    step2 = board[step1].send(step) if step1 && board[step1].empty?
    step2 ? [step2] : []
  end

  def all_moves(directions, cell, board)
    directions.each_with_object([]) do |direction, moves|
      result = board[cell].send(direction)
      next unless result

      moves.concat(recursive_moves(result, direction, board))
    end
  end

  def single_step_moves(steps_possible, cell, board)
    steps_possible.each_with_object([]) do |step, moves|
      result = board[cell].send(step)
      moves << result if result
    end
  end

  def recursive_moves(cell, direction, board, moves = [])
    return moves << cell if board[cell].send(direction).nil? || board[cell].occupied?

    moves << cell
    recursive_moves(board[cell].send(direction), direction, board, moves)
  end
end
