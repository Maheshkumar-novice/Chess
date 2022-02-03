#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../display/string-color-formatter'

# Prints the board in the terminal
class BoardPrinter
  LIGHT_BG = :bg_gray
  DARK_BG = :bg_cyan
  SOURCE_BG = :bg_magenta
  EMPTY_BG = :bg_green
  CAPTURE_BG = :bg_red

  include StringColorFormatter

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
    puts ('a'..'h').to_a.map { |value| gray_bold("  #{value}") }.join.prepend('  ')
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
    print gray_bold(" #{@row_no} " + ending) if condition
  end

  def print_cell(cell, bg_color)
    print color_cell(" #{cell} ", bg_color)
  end

  def printable_cell(key)
    return ' ' if @board[key].empty?

    @board[key]
  end

  def get_bg_color(key)
    return SOURCE_BG if @source == key
    return CAPTURE_BG if @captures.include?(key)
    return EMPTY_BG if @empty.include?(key)

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
