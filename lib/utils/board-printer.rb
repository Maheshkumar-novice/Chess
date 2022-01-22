#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './color'

# Board Printer
class BoardPrinter
  def print_board(board, source = nil, empty = [], captures = [])
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
    print " #{cell} ".send(bg_color).black
  end

  def get_bg_color(key, source, empty, captures, default_bg_color)
    return :bg_magenta if source == key
    return :bg_red if captures.include?(key)
    return :bg_green if empty.include?(key)

    default_bg_color
  end
end
