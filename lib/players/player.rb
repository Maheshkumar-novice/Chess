#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './utils/name-creator'
require_relative '../cell/utils/cell-choice-creator'

#  Represents Player
class Player
  attr_accessor :name

  def initialize(name_creator, cell_choice_creator)
    @name = nil
    @name_creator = name_creator
    @cell_choice_creator = cell_choice_creator
  end
end
