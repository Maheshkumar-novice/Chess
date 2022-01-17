#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './bot'
require_relative './human'

# Players Creator
class PlayersCreator
  def initialize
    @mode = ''
    @players = []
  end

  def create_players
    print_modes
    choose_mode
    create_players_of_mode
    create_names
    assign_colors
    create_players_hash
  end

  private

  def print_modes
    puts <<~MODES
      Modes:
        a. Bot vs Bot
        b. Bot vs Human
        c. Human vs Human

    MODES
  end

  def choose_mode
    @mode = mode_input until valid_mode?
    @mode = @mode.to_sym
  end

  def mode_input
    print 'Enter Your Option [a, b, c] > '
    gets.chomp
  end

  def valid_mode?
    @mode.match?(/^[abc]{1}$/)
  end

  def create_players_of_mode
    @players = {
      a: [new_bot_player, new_bot_player],
      b: [new_bot_player, new_human_player],
      c: [new_human_player, new_human_player]
    }[@mode]
  end

  def new_bot_player
    Bot.new
  end

  def new_human_player
    Human.new
  end

  def create_names
    @players.each(&:create_name)
  end

  def assign_colors
    colors = %w[white black].shuffle
    @players = @players.shuffle
    @players[0].color = colors[0]
    @players[1].color = colors[1]
  end

  def create_players_hash
    players = {}
    players[:white] = @players.select { |player| player.color == 'white' }
    players[:black] = @players.select { |player| player.color == 'black' }
    players
  end
end
