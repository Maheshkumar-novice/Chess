#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/display-utils/title'
require_relative './lib/display-utils/string-color-formatter'
require_relative './lib/board/board-operator'
require_relative './lib/board/utils/board-creator'
require_relative './lib/players/utils/player-creator'
require_relative './lib/fen/fen-processor'
require_relative './lib/chess-game/game'
require_relative './lib/file/file-loader'

# Chess Game Launcher
class Launcher
  include Title
  include StringColorFormatter

  def initialize
    @fen, @pieces, @current_color, @meta_data, @board, @board_operator, @players, @game = nil
    @file_loader = FileLoader.new
    @fen_processor = FenProcessor.new
    @board_creator = BoardCreator.new
    @player_creator = PlayerCreator.new
  end

  def launch
    title
    return play_saved_game if user_wants_to_load?

    play_fen_game
  end

  def user_wants_to_load?
    print_prompt('Do you want to load a saved game (y/n)?', ending: ' ')
    return true if gets.chomp.downcase == 'y'

    false
  end

  def play_saved_game
    @game = @file_loader.load
    return play_default_game unless @game

    @game.play
  end

  def play_default_game
    print_info('No saved games found! Loading default game.', ending: "\n\n")
    play_fen_game
  end

  def play_fen_game
    load_fen
    create_data_from_fen
    create_board
    create_board_operator
    create_players
    launch_game
  end

  def load_fen
    @fen = cli_fen || default_fen
  end

  def cli_fen
    cli_arg = ARGV.join(' ')
    ARGV.clear
    parse_cli_arg(cli_arg)
  end

  def parse_cli_arg(cli_arg)
    return nil if cli_arg.empty?

    cli_arg
  end

  def default_fen
    'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
  end

  def create_data_from_fen
    @fen_processor.process(@fen)
    @pieces = @fen_processor.pieces
    @current_color = @fen_processor.current_color
    @meta_data = @fen_processor.meta_data
  end

  def create_board
    @board = @board_creator.create_board(@pieces)
  end

  def create_board_operator
    @board_operator = BoardOperator.new(@board, @meta_data)
  end

  def create_players
    @players = @player_creator.create_players
    @players.rotate! if @current_color == 'black'
  end

  def launch_game
    @game = Game.new(@board_operator, @players, @current_color)
    @game.play
  end
end

# Driver
Launcher.new.launch
