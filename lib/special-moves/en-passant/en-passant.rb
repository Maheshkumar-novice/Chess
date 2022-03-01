#!/usr/bin/env ruby
# frozen_string_literal: true

# En Passant
class EnPassant
  def en_passant?(source, destination, board, meta_data)
    board[source].pawn? && meta_data.en_passant_move == destination
  end

  def en_passant_capture_cell(color, destination, board)
    color == 'white' ? board[destination].column_below : board[destination].column_above
  end

  def create_en_passant_move(source, destination, board)
    satisfy_en_passant_conditions?(source, destination, board) ? en_passant_move_of_source(source, board) : :-
  end

  def satisfy_en_passant_conditions?(source, destination, board)
    board[source].pawn? && pawn_double_step?(source, destination, board)
  end

  def pawn_double_step?(source, destination, board)
    return white_pawn_double_step?(source, destination, board) if board[source].white_piece?

    black_pawn_double_step?(source, destination, board)
  end

  def white_pawn_double_step?(source, destination, board)
    step1 = board[source].column_above
    step2 = board[step1].column_above
    step2 == destination
  end

  def black_pawn_double_step?(source, destination, board)
    step1 = board[source].column_below
    step2 = board[step1].column_below
    step2 == destination
  end

  def en_passant_move_of_source(source, board)
    source_cell = board[source]
    source_cell.white_piece? ? source_cell.column_above : source_cell.column_below
  end
end
