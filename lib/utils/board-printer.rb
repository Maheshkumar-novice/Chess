#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './color'

# Board Printer
class BoardPrinter
  def print_board(board, source = [], empty = [], captures = [])
    print_column_info
    print_board_data(board, source, empty, captures)
    print_column_info
  end

  private

  def print_column_info
    column_info = ('a'..'h').to_a.map { |value| "  #{value}".bold.gray }.join.prepend('  ')
    puts <<~COLUMN
      #{column_info}
    COLUMN
  end

  def print_board_data(board, source, empty, captures)
    default_bg_color = :bg_cyan
    row = 9

    board.each do |key, cell|
      print " #{row -= 1} ".bold.gray if key.match?(/a/)
      default_bg_color = switch_bg(default_bg_color)
      print_cell(cell, get_bg_color(key, source, empty, captures, default_bg_color))
      next unless key.match?(/h/)

      print " #{row} \n".bold.gray
      default_bg_color = switch_bg(default_bg_color)
    end
  end

  def switch_bg(bg_color)
    bg_color == :bg_cyan ? :bg_gray : :bg_cyan
  end

  def print_cell(cell, bg_color)
    piece = cell.piece&.name
    piece = printable_piece(piece)
    print colorize_cell(piece, bg_color)
  end

  def printable_piece(piece)
    return ' ' if piece.nil?

    symbol_to_unicode(piece.to_sym)
  end

  def colorize_cell(piece, bg_color)
    " #{piece} ".send(bg_color).black
  end

  def symbol_to_unicode(piece_symbol)
    {
      r: "\u265C", R: "\u2656",
      n: "\u265E", N: "\u2658",
      b: "\u265D", B: "\u2657",
      q: "\u265B", Q: "\u2655",
      k: "\u265A", K: "\u2654",
      p: "\u265F", P: "\u2659"
    }[piece_symbol]
  end

  def get_bg_color(key, source, empty, captures, default_bg_color)
    return :bg_magenta if source == key
    return :bg_red if captures.include?(key)
    return :bg_green if empty.include?(key)

    default_bg_color
  end
end
