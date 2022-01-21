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
    loop do
      @mode = mode_input
      return if valid_mode?

      print_error('Enter a valid option!', ending: "\n")
    end
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

  def valid_mode?
    @mode.match?(/^[a-d]{1}$/)
  end

  def print_modes
    str = <<~MODES
      #{print_info(accent('Modes: '))}
        a. Bot vs Bot
        b. Bot vs Human
        c. Human vs Bot
        d. Human vs Human

      #{print_info("\n* First player gets the #{accent('white')} color", ending: "\n")}
    MODES
    print_info(str, ending: "\n")
  end

  def mode_input
    print_prompt('Enter Your Option [a, b, c, d] > ')
    gets.chomp
  end

  def new_bot_player
    Bot.new
  end

  def new_human_player
    Human.new
  end
end
