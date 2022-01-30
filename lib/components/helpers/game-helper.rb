#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../output/string-color-formatter'

# Helper methods for Game
module GameHelper
  include StringColorFormatter

  def source_input
    loop do
      print_info_if_human("\nSource:")
      @source_choice = @current_player.make_choice.to_sym
      return if valid_source?

      print_error_if_human('Enter a valid source coordinate!')
    end
  end

  def create_moves
    @moves = @board_operator.moves_from_source(@source_choice, @current_color)
  end

  def valid_source?
    return false unless same_color?

    true
  end

  def valid_destination?
    return false unless moves_include_destination?

    true
  end

  def same_color?
    @board_operator.board[@source_choice].color?(@current_color)
  end

  def moves_empty?
    @moves.values.all?(&:empty?)
  end

  def moves_include_destination?
    @moves.values.flatten.include?(@destination_choice)
  end

  def sleep_if_bot
    sleep(1) if @current_player.is_a?(Bot)
  end

  def print_board
    system('clear')
    @printer.print_board(@board_operator.board, @source_choice, @moves[:empty], @moves[:captures])
  end

  def print_check_status
    text = "Is your king in check? #{accent(@board_operator.king_in_check?(@current_color).to_s)}"
    condition = @current_player.is_a?(Human)
    print_info_if(text, condition: condition, ending: "\n")
  end

  def print_current_player_info
    text = "#{accent(@current_player.name)}'s move (#{accent(@current_color)}):"
    print_info(text, ending: "\n")
  end

  def print_error_if_human(str)
    condition = @current_player.is_a?(Human)
    print_error_if(str, condition: condition, ending: "\n")
  end

  def print_info_if_human(str)
    condition = @current_player.is_a?(Human)
    print_info_if(str, condition: condition, ending: "\n")
  end
end
