#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../components/output/board-printer'
require_relative '../components/helpers/game-helper'

# Controls game play
class Game
  include GameHelper

  def initialize(board_operator, players, current_color, printer: BoardPrinter.new)
    @board_operator = board_operator
    @current_player, @other_player = players
    @current_color = current_color
    @printer = printer
    @source_choice = nil
    @destination_choice = nil
    @moves = { empty: [], captures: [] }
  end

  def play
    loop do
      break if game_over?

      print_board
      print_current_player_info
      sleep_if_bot
      move_making_steps
      switch_current_color
      switch_players
    end
  end

  def game_over?
    @board_operator.checkmate?(@current_color) || @board_operator.stalemate?(@current_color)
  end

  def move_making_steps
    print_check_status
    create_source_choice
    print_board
    print_current_player_info
    create_destination_choice
    make_move
    print_board
  end

  def create_source_choice
    loop do
      source_input
      create_moves
      return unless moves_empty?

      print_error_if_human('No legal moves found from the selected source!')
    end
  end

  def create_destination_choice
    loop do
      print_info_if_human("\nDestination:")
      @destination_choice = @current_player.make_choice.to_sym
      return if valid_destination?

      print_error_if_human('Enter a valid move from the selected source!')
    end
  end

  def make_move
    @board_operator.make_move(@source_choice, @destination_choice)
  end

  def switch_current_color
    @current_color = @current_color == 'white' ? 'black' : 'white'
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end
end
