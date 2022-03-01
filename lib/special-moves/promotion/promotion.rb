#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './utils/promotion-piece-creator'

# Promotion handler
class Promotion
  def initialize
    @promotion_piece_creator = PromotionPieceCreator.new
  end

  def promotion?(destination, board)
    board[destination].pawn? && destination.match?(/^[a-h]8$|^[a-h]1$/)
  end

  def promote(destination, board, current_color, current_player)
    piece = @promotion_piece_creator.promotion_piece(destination, current_color, current_player)
    board[destination].update_piece_to(piece)
  end
end
