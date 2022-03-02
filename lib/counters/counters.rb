#!/usr/bin/env ruby
# frozen_string_literal: true

# Half Move Clock and Full Move Number Counters
class Counters
  def initialize
    @half_move_clock = 0
    @full_move_number = 1
  end

  def update_half_move_clock(value)
    @half_move_clock = value.to_i
  end

  def update_full_move_number(value)
    @full_move_number = value.to_i
  end

  def update_counters(source, destination, board, color)
    half_move_reset?(source, destination, board) ? reset_half_move_clock : increment_half_move_clock
    increment_full_move_number if full_move?(color)
  end

  def half_move_reset?(source, destination, board)
    board[source].pawn? || board[destination].occupied?
  end

  def full_move?(color)
    color == 'black'
  end

  def increment_half_move_clock
    @half_move_clock += 1
  end

  def increment_full_move_number
    @full_move_number += 1
  end

  def reset_half_move_clock
    @half_move_clock = 0
  end

  def fifty_move_rule?
    @half_move_clock == 50
  end

  def to_s
    "#{@half_move_clock} #{@full_move_number}"
  end
end
