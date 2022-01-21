#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './utils/display'

# Game
class Game
  include Display

  def initialize(board, players, current_color)
    @board = board
    @current_player = players[0]
    @other_player = players[1]
    @current_color = current_color
    @source_choice = nil
    @destination_choice = nil
    @moves = { empty: [], captures: [] }
  end

  def play
    loop do
      print_board
      print_current_player_info
      sleep_if_bot
      move_making_steps
      switch_current_color
      switch_players
    end
  end

  def move_making_steps
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

  def source_input
    loop do
      print_info_if_human("\nSource:")
      @source_choice = @current_player.make_choice.to_sym

      return if valid_source?

      print_error_if_human('Enter a valid source coordinate!')
    end
  end

  def valid_source?
    return false unless same_color?

    true
  end

  def same_color?
    @board.board[@source_choice].piece&.color == @current_color
  end

  def create_moves
    @moves = @board.moves_from_source(@source_choice, @current_color)
  end

  def moves_empty?
    @moves.values.flatten.empty?
  end

  def create_destination_choice
    loop do
      print_info_if_human("\nDestination:")
      @destination_choice = @current_player.make_choice.to_sym

      return if valid_destination?

      print_error_if_human('Enter a valid move from the selected source!')
    end
  end

  def valid_destination?
    return false unless moves_include_destination?

    true
  end

  def moves_include_destination?
    @moves.values.flatten.include?(@destination_choice)
  end

  def make_move
    @board.make_move(@source_choice, @destination_choice)
  end

  def switch_current_color
    @current_color = @current_color == 'white' ? 'black' : 'white'
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  private

  def print_board
    system('clear')
    @board.print_board(@source_choice, @moves[:empty], @moves[:captures])
  end

  def print_current_player_info
    print_info("#{accent(@current_player.name)}'s move (#{accent(@current_color)}):", ending: "\n")
  end

  def print_error_if_human(str)
    print_error_if(str, condition: @current_player.is_a?(Human),
                        ending: "\n")
  end

  def print_info_if_human(str)
    print_info_if(str, condition: @current_player.is_a?(Human),
                       ending: "\n")
  end

  def sleep_if_bot
    sleep(1) if @current_player.is_a?(Bot)
  end
end
