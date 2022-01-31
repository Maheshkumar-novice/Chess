#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../components/output/string-color-formatter'

# Helper methods for Game
module GameHelper
  include StringColorFormatter

  def sleep_if_bot
    sleep(1) if @current_player.is_a?(Bot)
  end

  def print_data(additional_info: '')
    system('clear')
    @info.title
    print_board
    print_info_if_human(additional_info)
    print_current_player_info
    print_check_status
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
    text = "Is your king in check? #{accent(@board_operator.king_in_check?(@current_color).to_s)}"
    condition = @current_player.is_a?(Human)
    print_info_if(text, condition: condition, ending: "\n\n")
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
