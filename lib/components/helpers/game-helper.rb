#!/usr/bin/env ruby
# frozen_string_literal: true

# Helper methods for Game
module GameHelper
  def sleep_if_bot
    sleep(1) if @current_player.is_a?(Bot)
  end

  def print_board
    system('clear')
    @printer.print_board(@board.board, @source_choice, @moves[:empty], @moves[:captures])
  end

  def print_check_status
    print_info_if("Is your king in check? #{accent(@board.king_in_check?(@current_color).to_s)}",
                  condition: @current_player.is_a?(Human), ending: "\n")
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
end
