#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../components/output/string-color-formatter'

# Result Handler
class Result
  include StringColorFormatter

  def initialize
    @draw = false
    @checkmate = false
    @stalemate = false
  end

  def update_draw(value)
    @draw = value
  end

  def any?
    [@draw, @checkmate, @stalemate].any?
  end

  def update_mates(board_operator, color)
    @checkmate = board_operator.checkmate?(color)
    @stalemate = board_operator.stalemate?(color)
  end

  def announce(game)
    announce_draw if @draw
    announce_checkmate(game) if @checkmate
    announce_stalemate if @stalemate
  end

  def announce_draw
    print_info("\nIt's a Draw! :(", ending: "\n")
  end

  def announce_checkmate(game)
    current_player = game.current_player
    other_player = game.other_player
    text = "\n#{accent(current_player.name)} Checkmated by #{accent(other_player.name)} :P"
    print_info(text, ending: "\n")
  end

  def announce_stalemate
    print_info("\nIt's a Stalemate! :(", ending: "\n")
  end

  def announce_player_resignation(game)
    current_player = game.current_player
    other_player = game.other_player
    text = "\n#{accent(current_player.name)} Resigned. #{accent(other_player.name)} Won!"
    print_info(text, ending: "\n")
  end
end
