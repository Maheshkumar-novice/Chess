#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../utils/chess-unicode'
require_relative '../utils/color'

# Board Printer
module BoardPrinter
  include ChessUnicode

  def print_board(source, empty = [], captures = [])
    print_column_info
    print_board_data(source, empty, captures)
    print_column_info
  end

  private

  def print_column_info
    print '  '
    ('a'..'h').each do |value|
      print "  #{value}"
    end
    puts
  end

  def print_board_data(source, empty, captures)
    default_bg_color = :bg_cyan
    row = 9

    @board.each do |key, cell|
      print " #{row -= 1} " if key.match?(/a/)
      default_bg_color = switch_bg(default_bg_color)
      print_cell(cell, get_bg_color(key, source, empty, captures, default_bg_color))
      next unless key.match?(/h/)

      print " #{row} \n"
      default_bg_color = switch_bg(default_bg_color)
    end
  end

  def switch_bg(bg_color)
    bg_color == :bg_cyan ? :bg_gray : :bg_cyan
  end

  def print_cell(cell, key, bg_color, source, empty, captures)
    bg_color = :bg_magenta if source == key
    bg_color = :bg_red if captures.include?(key)
    bg_color = :bg_green if empty.include?(key)
    piece_symbol = cell.piece&.name.to_s.to_sym
    print colorize_cell(piece_symbol, bg_color)
  end

  def colorize_cell(piece_symbol, bg_color)
    piece = character_to_unicode(piece_symbol) unless piece_symbol == :""
    piece = ' ' if piece_symbol == :""
    " #{piece} ".send(bg_color).black
  end
end
