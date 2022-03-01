#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../display/string-color-formatter'

# Result Handler
class Result
  include StringColorFormatter

  def initialize
    @manual_draw = false
    @fifty_move_rule_draw = false
    @checkmate = false
    @stalemate = false
    @resign = false
  end

  def update_manual_draw(value)
    @manual_draw = value
  end

  def update_fifty_move_rule_draw(value)
    @fifty_move_rule_draw = value
  end

  def update_checkmate(value)
    @checkmate = value
  end

  def update_stalemate(value)
    @stalemate = value
  end

  def update_resign(value)
    @resign = value
  end

  def any?
    [@manual_draw, @fifty_move_rule_draw, @checkmate, @stalemate, @resign].any?
  end

  def announce(game)
    return announce_draw if @manual_draw
    return announce_fifty_move_rule_draw if @fifty_move_rule_draw
    return announce_checkmate(game) if @checkmate
    return announce_stalemate if @stalemate
    return announce_player_resignation(game) if @resign
  end

  private

  def announce_draw
    print_info("It's a Draw! :(", ending: "\n", starting: "\n")
  end

  def announce_fifty_move_rule_draw
    print_info("It's a Draw by 50 move rule! :(", ending: "\n", starting: "\n")
  end

  def announce_checkmate(game)
    text = "#{accent(game.current_player_name)} Checkmated by #{accent(game.other_player_name)} :P"
    print_info(text, ending: "\n", starting: "\n")
  end

  def announce_stalemate
    print_info("It's a Stalemate! :(", ending: "\n", starting: "\n")
  end

  def announce_player_resignation(game)
    text = "#{accent(game.current_player_name)} Resigned. #{accent(game.other_player_name)} Won!"
    print_info(text, ending: "\n", starting: "\n")
  end
end
