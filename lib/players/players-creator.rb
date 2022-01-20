#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './bot'
require_relative './human'
require_relative '../utils/display'

# Players Creator
class PlayersCreator
  include Display

  def initialize
    @mode = ''
    @players = []
  end

  def create_players
    print_modes
    choose_mode
    @players = create_players_of_mode
    create_names
    @players
  end

  def choose_mode
    @mode = mode_input
    until valid_mode?
      print_error('Enter a valid option!', ending: "\n")
      @mode = mode_input
    end
  end

  def create_players_of_mode
    case @mode
    when 'a'
      [new_bot_player, new_bot_player].shuffle
    when 'b'
      [new_bot_player, new_human_player].shuffle
    when 'c'
      [new_human_player, new_human_player].shuffle
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

  def valid_mode?
    @mode.match?(/^[abc]{1}$/)
  end

  def print_modes
    str = <<~MODES
      #{print_info(accent('Modes: '))}
        a. Bot vs Bot
        b. Bot vs Human
        c. Human vs Human

    MODES
    print_info(str, ending: "\n")
  end

  def mode_input
    print_prompt('Enter Your Option [a, b, c] > ')
    gets.chomp
  end

  def new_bot_player
    Bot.new
  end

  def new_human_player
    Human.new
  end
end
