#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './result'
require_relative './command'
require_relative './utils/game-helper'
require_relative '../board/utils/board-printer'

# Controls the game play
class Game
  include GameHelper

  attr_reader :current_color

  def initialize(board_operator, players, current_color)
    @board_operator = board_operator
    @current_player, @other_player = players
    @current_color = current_color
    @result = Result.new
    @command = Command.new
    @printer = BoardPrinter.new
    @source_choice = nil
    @destination_choice = nil
    @moves = { empty: [], captures: [] }
  end

  def play
    game_loop
    announce_result
  end

  def game_loop
    loop do
      print_data
      update_result
      return if game_over?

      create_source_choice
      create_destination_choice
      make_move
    end
  end

  def update_result
    update_draw
    update_mates
  end

  def update_draw
    @command.propose_draw(@current_player, @current_color)
    @result.update_draw(@command.draw_approval_status)
  end

  def update_mates
    @result.update_checkmate(@board_operator.checkmate?(@current_color))
    @result.update_stalemate(@board_operator.stalemate?(@current_color))
  end

  def game_over?
    @result.any?
  end

  def create_source_choice
    pre_source_input_print
    make_source
  end

  def make_source
    loop do
      source_choice_input
      @moves = create_moves_for_source
      return unless moves_empty?

      print_error('No valid moves found!', ending: "\n") if human?
    end
  end

  def source_choice_input
    loop do
      choice = @current_player.make_choice.to_sym
      next @command.execute(self, @result) if choice == :cmd

      @source_choice = choice
      return if valid_source?

      print_error('Enter a valid choice!', ending: "\n") if human?
    end
  end

  def create_destination_choice
    pre_destination_input_print
    make_destination
  end

  def make_destination
    loop do
      @destination_choice = @current_player.make_choice.to_sym
      return if valid_destination?

      print_error('Enter a valid move from the selected source!', ending: "\n") if human?
    end
  end

  def make_move
    @board_operator.make_move(@source_choice, @destination_choice)
    switch_current_color
    switch_players
    update_moves_for_post_move_print
  end

  def switch_current_color
    @current_color = @current_color == 'white' ? 'black' : 'white'
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def announce_result
    @result.announce(self)
  end
end
