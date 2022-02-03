#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../components/output/string-color-formatter'
require_relative '../components/output/title'

# Helper methods for Game
module GameHelper
  include StringColorFormatter
  include Title

  def current_player_name
    @current_player.name
  end

  def other_player_name
    @other_player.name
  end

  private

  def valid_source?
    @board_operator.board[@source_choice].color?(@current_color)
  end

  def create_moves_for_source
    @board_operator.moves_from_source(@source_choice, @current_color)
  end

  def moves_empty?
    @moves.values.all?(&:empty?)
  end

  def valid_destination?
    @moves.values.flatten.include?(@destination_choice)
  end

  def update_moves_for_post_move_print
    @moves = { empty: [@destination_choice], captures: [] }
  end

  def sleep_if_bot
    sleep(1) unless human?
  end

  def print_data(additional_info: '')
    system('clear')
    title
    print_board
    print_current_player_info
    print_check_status
    print_draw_proposal_status
    print_info(additional_info, ending: '')
  end

  def human?
    @current_player.is_a?(Human)
  end

  def pre_source_print
    sleep_if_bot
    print_data(additional_info: source_input_text)
  end

  def pre_destination_print
    print_data(additional_info: destination_input_text)
  end

  def source_input_text
    <<~SOURCE

      Source #{accent('(e.g. a1)')} / Command Mode #{accent('(cmd)')}:
    SOURCE
  end

  def destination_input_text
    <<~DESTINATION

      Destination(e.g. a1):
    DESTINATION
  end

  def print_board
    @printer.print_board(@board_operator.board, @source_choice, @moves[:empty], @moves[:captures])
  end

  def print_check_status
    value = @board_operator.king_in_check?(@current_color)
    ending = create_ending(value)
    print_error('Your king is in check!', ending: ending) if value
  end

  def print_current_player_info
    text = "#{accent(@current_player.name)}'s move (#{accent(@current_color)}):"
    print_info(text, ending: "\n", starting: "\n")
  end

  def print_draw_proposal_status
    value = @command.draw_proposer_color
    text = "Draw proposal activated by #{accent(value.to_s)}"
    ending = create_ending(value)
    print_info(text, ending: ending) if value
  end

  def create_ending(value)
    return '' unless value

    "\n"
  end
end
