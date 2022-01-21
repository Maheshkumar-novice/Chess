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
  end

  def play
    loop do
      print_board
      print_current_player_info
      sleep_if_bot
      make_move
      switch_current_color
      switch_players
    end
  end

  private

  def make_move
    loop do
      @source_choice = source_input
      moves = @board.moves_from_source(@source_choice, @current_color)
      next print_error_if_human('No legal moves found from the selected source!') if moves.values.flatten.size.zero?

      print_board(@source_choice, moves[:empty], moves[:captures])
      @destination_choice = destination_input(moves)
      @board.make_move(@source_choice, @destination_choice)
      print_board(@source_choice, moves[:empty], moves[:captures])
      break
    end
  end

  def source_input
    loop do
      print_info_if_human("\nSource:")
      source = @current_player.make_choice

      return source.to_sym if valid_source?(source)

      print_error_if_human('Enter a valid source coordinate!')
    end
  end

  def destination_input(moves)
    print_current_player_info
    loop do
      print_info_if_human("\nDestination:")
      destination = @current_player.make_choice

      return destination.to_sym if valid_destination?(destination, moves)

      print_error_if_human('Enter a valid move from the selected source!')
    end
  end

  def valid_source?(source)
    return false unless source.match?(/^[a-h][1-8]$/)
    return false unless same_color?(source.to_sym)

    true
  end

  def same_color?(source)
    @board.board[source].piece&.color == @current_color
  end

  def valid_destination?(destination, moves)
    return false unless destination.match?(/^[a-h][1-8]$/)
    return false unless moves.values.flatten.include?(destination.to_sym)

    true
  end

  def switch_current_color
    @current_color = @current_color == 'white' ? 'black' : 'white'
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def print_board(source = nil, empty = [], captures = [])
    clear_screen
    @board.print_board(source, empty, captures)
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

  def clear_screen
    system('clear')
  end

  def sleep_if_bot
    sleep(1) if @current_player.is_a?(Bot)
  end
end
