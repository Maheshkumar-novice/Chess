#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './chess'

fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
fen_processor = Fen.new
fen_processor.process(fen)
pieces = fen_processor.pieces
current_color = fen_processor.current_color
meta_data = fen_processor.meta_data

board = BoardCreator.new.create_board(pieces)
board_operator = BoardOperator.new(board, meta_data)

players = PlayerCreator.new.create_players
players.rotate! if current_color == 'black'

game = Game.new(board_operator, players, current_color)
game.play
