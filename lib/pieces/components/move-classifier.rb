#!/usr/bin/env ruby
# frozen_string_literal: true

# Move Classifier
class MoveClassifier
  def classify_moves(color, moves, board)
    enemy_color = color == 'white' ? 'black' : 'white'

    result = {
      captures: [],
      empty: []
    }
    moves.each_with_object(result) do |move, classified|
      classified[:empty] << move unless board[move].occupied?
      classified[:captures] << move if board[move].piece_color == enemy_color
    end
  end
end
