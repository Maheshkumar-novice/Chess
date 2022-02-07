#!/usr/bin/env ruby
# frozen_string_literal: true

# Meta Data about Moves
class MovesMetaData
  attr_accessor :en_passant

  def initialize
    @en_passant = :-
  end

  def update(source, destination)
    update_en_passant(source, destination)
  end

  def update_en_passant(source, destination, piece_name)
    return @en_passant = :- unless satisfy_en_passant_conditions?(source, destination, piece_name)

    @en_passant = create_en_passant(source)
  end

  def satisfy_en_passant_conditions?(source, destination, piece_name)
    piece_name.downcase == 'p' && double_step?(source, destination)
  end

  def double_step?(source, destination)
    start = source.to_s[1].to_i
    ending = destination.to_s[1].to_i
    (start - ending).abs == 2
  end

  def create_en_passant(source)
    str = source.to_s
    (str[0] + (str[1].to_i + 1)).to_sym
  end
end
