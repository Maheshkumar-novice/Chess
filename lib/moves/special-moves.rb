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

  def castling?(source, destination, board, moves, castling_rights)
    board[source].king? && castling_move(moves, board, source, castling_rights,
                                         board[source].piece_color).include?(destination)
  end

  def castling_move(moves, board, source, castling_rights, color)
    return [] if castling_rights.empty?

    available_castlings = castlings_of_color(color, castling_rights)
    available_castlings.select! { |castling| castling_has_adjacent_move?(moves, adjacent_move(castling, board)) }
    available_castlings.select! { |castling| cells_between_king_and_rook_empty?(source, castling, board, color) }
    return [] if available_castlings.empty?

    available_castlings
  end

  def cells_between_king_and_rook_empty?(source, castling_move, board, color)
    direction = queen_side_castling?(castling_move) ? :row_left : :row_right
    rook_cell = rook_cell(color, castling_move)
    cell = board[board[source].send(direction)]
    loop do
      return false if cell.occupied?
      return true if cell.send(direction) == rook_cell

      cell = board[cell.send(direction)]
    end
  end

  def rook_cell(color, castling_move)
    return whtie_rook_cell(castling_move) if color == 'white'

    black_rook_cell(castling_move)
  end

  def whtie_rook_cell(castling_move)
    queen_side_castling?(castling_move) ? :a1 : :h1
  end

  def black_rook_cell(castling_move)
    queen_side_castling?(castling_move) ? :a8 : :h8
  end

  def castling_has_adjacent_move?(moves, adjacent_move)
    moves.include?(adjacent_move)
  end

  def adjacent_move(castling, board)
    direction = queen_side_castling?(castling) ? :row_right : :row_left
    board[castling].send(direction)
  end

  def queen_side_castling?(castling_move)
    %i[c1 c8].any? { |move| move == castling_move }
  end

  def castlings_of_color(color, castling_rights)
    return white_castlings(castling_rights) if color == 'white'

    black_castlings(castling_rights)
  end

  def white_castlings(castling_rights)
    rights = []
    rights << :g1 if castling_rights.include?('K')
    rights << :c1 if castling_rights.include?('Q')
    rights
  end

  def black_castlings(castling_rights)
    rights = []
    rights << :g8 if castling_rights.include?('k')
    rights << :c8 if castling_rights.include?('q')
    rights
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
