#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './color'

# Board Printer
class BoardPrinter
  LIGHT_BG = :bg_gray
  DARK_BG = :bg_cyan

  def initialize
    @board = nil
    @source = nil
    @empty = []
    @captures = []
    @default_bg_color = LIGHT_BG
    @row_no = 8
  end

  def print_board(board, source = nil, empty = [], captures = [])
    instance_variables_set(board, source, empty, captures)
    print_column_info
    print_board_data
    print_column_info
  end

  private

  def instance_variables_set(board, source, empty, captures)
    @board = board
    @source = source
    @empty = empty
    @captures = captures
  end

  def print_column_info
    puts ('a'..'h').to_a.map { |value| row_column_color("  #{value}") }.join.prepend('  ')
  end

  def print_board_data
    @board.each_key do |key|
      print_row_no(condition: key.match?(/a/))
      print_cell(printable_cell(key), get_bg_color(key))
      switch_bg
      next unless key.match?(/h/)

      print_row_no(ending: "\n")
      switch_bg
      decrement_row_no
    end
    reset
  end

  def print_row_no(condition: true, ending: '')
    print row_column_color(" #{@row_no} " + ending) if condition
  end

  def row_column_color(str)
    str.bold.gray
  end

  def print_cell(cell, bg_color)
    print " #{cell} ".send(bg_color).black
  end

  def printable_cell(key)
    return ' ' if @board[key].empty?

    @board[key]
  end

  def get_bg_color(key)
    return :bg_magenta if @source == key
    return :bg_red if @captures.include?(key)
    return :bg_green if @empty.include?(key)

    @default_bg_color
  end

  def switch_bg
    @default_bg_color = @default_bg_color == DARK_BG ? LIGHT_BG : DARK_BG
  end

  def decrement_row_no
    @row_no -= 1
  end

  def reset
    initialize
  end
end
