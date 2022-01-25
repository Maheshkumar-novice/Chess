#!/usr/bin/env ruby
# frozen_string_literal: true

#  Represents Player
class Player
  attr_accessor :name

  def initialize(name_creator, cell_choice_creator)
    @name = nil
    @name_creator = name_creator
    @cell_choice_creator = cell_choice_creator
  end
end
