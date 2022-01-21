#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './bot'
require_relative './human'
require_relative './components/mode-chooser'
require_relative '../utils/display'

# Players Creator
class PlayersCreator
  include Display

  def initialize(mode_chooser: ModeChooser.new)
    @mode_chooser = mode_chooser
    @mode = nil
    @players = []
  end

  def create_players
    @mode = @mode_chooser.choose_mode
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
