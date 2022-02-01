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
    @resign = false
  end

  def update_draw(value)
    @draw = value
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
    [@draw, @checkmate, @stalemate, @resign].any?
  end

  def announce(game)
    announce_draw if @draw
    announce_checkmate(game) if @checkmate
    announce_stalemate if @stalemate
    announce_player_resignation(game) if @resign
  end

  def announce_draw
    print_info("It's a Draw! :(", ending: "\n", starting: "\n")
  end

  def announce_checkmate(game)
    current_player = game.current_player
    other_player = game.other_player
    text = "#{accent(current_player.name)} Checkmated by #{accent(other_player.name)} :P"
    print_info(text, ending: "\n", starting: "\n")
  end

  def announce_stalemate
    print_info("It's a Stalemate! :(", ending: "\n", starting: "\n")
  end

  def announce_player_resignation(game)
    current_player = game.current_player
    other_player = game.other_player
    text = "#{accent(current_player.name)} Resigned. #{accent(other_player.name)} Won!"
    print_info(text, ending: "\n", starting: "\n")
  end
end
