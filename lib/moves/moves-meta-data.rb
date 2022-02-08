#!/usr/bin/env ruby
# frozen_string_literal: true

# Meta Data about Moves
class MovesMetaData
  attr_accessor :en_passant_move

  def initialize
    @source = nil
    @destination = nil
    @piece_name = nil
    @board = nil
    @en_passant_move = :-
  end

  def update(source, destination, piece_name, board)
    set_instance_variables(source, destination, piece_name, board)
    update_en_passant
  end

  def update_en_passant
    return @en_passant_move = :- unless satisfy_en_passant_conditions?

    @en_passant_move = create_en_passant_move
  end

  def satisfy_en_passant_conditions?
    @piece_name.downcase == 'p' && double_step?
  end

  def double_step?
    return white_double_step? if @board[@source].piece_color == 'white'

    black_double_step?
  end

  def white_double_step?
    step1 = @board[@source].column_above
    step2 = @board[step1].column_above
    step2 == @destination
  end

  def black_double_step?
    step1 = @board[@source].column_below
    step2 = @board[step1].column_below
    step2 == @destination
  end

  def create_en_passant_move
    source = @board[@source]
    return source.column_above if source.piece_color == 'white'

    source.column_below
  end

  def set_instance_variables(source, destination, piece_name, board)
    @source = source
    @destination = destination
    @piece_name = piece_name
    @board = board
  end
end
