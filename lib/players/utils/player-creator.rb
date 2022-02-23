#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './mode-creator'
require_relative '../bot'
require_relative '../human'

# Creates players depending on the mode
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
    when 'a' then [new_bot_player, new_bot_player]
    when 'b' then [new_bot_player, new_human_player]
    when 'c' then [new_human_player, new_bot_player]
    when 'd' then [new_human_player, new_human_player]
    end
  end

  def create_names
    @players.each_with_index do |player, index|
      print_player_data(index)
      player.create_name
      print_bot_name(player) if player.is_a?(Bot)
    end
  end

  def new_bot_player
    Bot.new
  end

  def new_human_player
    Human.new
  end

  private

  def print_player_data(index)
    colors = %w[white black]
    print_info("Player##{index + 1} (#{accent(colors[index])}): ", ending: "\n", starting: "\n")
  end

  def print_bot_name(player)
    print_info("#{accent(player.name)} (Bot)", ending: "\n")
    sleep(1)
  end
end
