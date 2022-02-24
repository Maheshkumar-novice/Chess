#!/usr/bin/env ruby
# frozen_string_literal: true

# Special Moves
class SpecialMoves
  def initialize
    @castling_right_of_cells = { a1: 'Q', e1: 'KQ', h1: 'K', a8: 'q', e8: 'kq', h8: 'k' }
  end

  def update_castling_rights(source, destination, castling_rights)
    return castling_rights if castling_rights.empty?

    [@castling_right_of_cells[source], @castling_right_of_cells[destination]].compact.each do |right|
      castling_rights = castling_rights.tr(right, '')
    end
    castling_rights
  end

  def en_passant?(source, destination, board, meta_data)
    board[source].pawn? && meta_data.en_passant_move == destination
  end

  def en_passant_capture_cell(color, destination, board)
    return board[destination].column_below if color == 'white'

    board[destination].column_above
  end

  def create_en_passant_move(source, destination, board)
    return :- unless satisfy_en_passant_conditions?(source, destination, board)

    en_passant_move_of_source(source, board)
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
    source = board[source]
    return source.column_above if source.white_piece?

    source.column_below
  end
end
