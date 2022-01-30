#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './result'
require_relative './command'
require_relative './game-helper'
require_relative '../components/output/board-printer'

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
    @source_choice = nil
    @destination_choice = nil
    @moves = { empty: [], captures: [] }
  end

  def play
    loop do
      print_data
      draw_proposal
      update_mate_results
      break if @result.any?

      make_source
      make_destination
      make_move
    end
    announce_result
  end

  def draw_proposal
    @command.propose_draw(@result, @current_player) if @command.draw_proposal?
  end

  def update_mate_results
    @result.update_mates(@board_operator, @current_color)
  end

  def make_source
    sleep_if_bot
    print_data(additional_info: source_input_text)
    loop do
      @source_choice = @current_player.make_choice.to_sym
      next @command.execute(self, @result) if @source_choice == :cmd
      next print_error_if_human('Enter a valid choice!') unless valid_source?

      create_moves
      break unless moves_empty?

      print_error_if_human('No valid moves found!')
    end
  end

  def valid_source?
    @board_operator.board[@source_choice].color?(@current_color)
  end

  def create_moves
    @moves = @board_operator.moves_from_source(@source_choice, @current_color)
  end

  def moves_empty?
    @moves.values.all?(&:empty?)
  end

  def make_destination
    print_data(additional_info: destination_input_text)
    loop do
      @destination_choice = @current_player.make_choice.to_sym
      break if valid_destination?

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
