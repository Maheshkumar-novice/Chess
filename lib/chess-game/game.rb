#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './result'
require_relative './command'
require_relative './game-helper'
require_relative '../components/output/board-printer'
require_relative '../components/output/info'

# Controls the game play
class Game
  include GameHelper

  attr_reader :current_player, :other_player

  def initialize(board_operator, players, current_color)
    @board_operator = board_operator
    @current_player, @other_player = players
    @current_color = current_color
    @result = Result.new
    @command = Command.new
    @printer = BoardPrinter.new
    @info = Info.new
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
    @command.propose_draw(@current_player)
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
    pre_source_print
    make_source
  end

  def make_source
    loop do
      source_choice_input
      create_moves_for_source
      return unless moves_empty?

      print_error_if_human('No valid moves found!')
    end
  end

  def source_choice_input
    loop do
      @source_choice = @current_player.make_choice.to_sym
      next @command.execute(self, @result) if @source_choice == :cmd
      return if valid_source?

      print_error_if_human('Enter a valid choice!')
    end
  end

  def valid_source?
    @board_operator.board[@source_choice].color?(@current_color)
  end

  def create_moves_for_source
    @moves = @board_operator.moves_from_source(@source_choice, @current_color)
  end

  def moves_empty?
    @moves.values.all?(&:empty?)
  end

  def create_destination_choice
    pre_destination_print
    make_destination
  end

  def make_destination
    loop do
      @destination_choice = @current_player.make_choice.to_sym
      return if valid_destination?

      print_error_if_human('Enter a valid move from the selected source!')
    end
  end

  def valid_destination?
    @moves.values.flatten.include?(@destination_choice)
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
