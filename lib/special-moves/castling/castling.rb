#!/usr/bin/env ruby
# frozen_string_literal: true

# Castling
class Castling
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

  def castlings_of_color(color, castling_rights)
    color == 'white' ? white_castlings(castling_rights) : black_castlings(castling_rights)
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

  def adjacent_move(castling_move, board)
    direction = queen_side_castling?(castling_move) ? :row_right : :row_left
    board[castling_move].send(direction)
  end

  def queen_side_castling?(castling_move)
    %i[c1 c8].include?(castling_move)
  end

  def castling_has_adjacent_move?(moves, adjacent_move)
    moves.include?(adjacent_move)
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
    color == 'white' ? whtie_rook_cell(castling_move) : black_rook_cell(castling_move)
  end

  def whtie_rook_cell(castling_move)
    queen_side_castling?(castling_move) ? :a1 : :h1
  end

  def black_rook_cell(castling_move)
    queen_side_castling?(castling_move) ? :a8 : :h8
  end
end
