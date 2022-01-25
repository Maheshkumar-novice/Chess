#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../players/bot'
require_relative '../../players/human'
require_relative '../output/string-color-formatter'
require_relative './mode-creator'

# Players Creator
class PlayerCreator
  include StringColorFormatter

  def initialize(mode_creator: ModeCreator.new)
    @mode_creator = mode_creator
    @mode = nil
    @players = []
  end

  def create_players
    @mode = @mode_creator.choose_mode
    @players = create_players_of_mode
    create_names
    @players
  end

  def create_players_of_mode
    case @mode
    when 'a'
      [new_bot_player, new_bot_player]
    when 'b'
      [new_bot_player, new_human_player]
    when 'c'
      [new_human_player, new_bot_player]
    when 'd'
      [new_human_player, new_human_player]
    end
  end

  def create_names
    colors = %w[white black]
    @players.each_with_index do |player, index|
      print_info("\nPlayer##{index + 1} name (#{accent(colors[index])}): ", ending: "\n")
      player.create_name
      print_info("#{accent(player.name)} (Bot)", ending: "\n") if player.is_a?(Bot)
    end
  end

  private

  def new_bot_player
    Bot.new
  end

  def new_human_player
    Human.new
  end
end