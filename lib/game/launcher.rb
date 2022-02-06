#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../monkey-patches/loader'
require_relative '../display/title'
require_relative '../display/string-color-formatter'
require_relative '../board/board-operator'
require_relative '../board/utils/board-creator'
require_relative '../players/utils/player-creator'
require_relative '../fen/fen-processor'
require_relative '../game/game'
require_relative '../yaml/yaml_loader'

# Chess Game Launcher
class Launcher
  include Title
  include StringColorFormatter

  def initialize
    @fen, @pieces, @current_color, @meta_data, @board, @board_operator, @players, @game = nil
    @yaml_loader = YAMLLoader.new
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
    load_game
    play_game
  end

  def load_game
    @game = @yaml_loader.load
  end

  def play_game
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
    ARGV[0]
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
    rotate_if_needed
  end

  def rotate_if_needed
    @players.rotate! if @current_color == 'black'
  end

  def launch_game
    @game = Game.new(@board_operator, @players, @current_color)
    @game.play
  end

  private

  def default_fen
    'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
  end
end
