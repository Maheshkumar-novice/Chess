#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './utils/name-creator'
require_relative '../cell/utils/cell-choice-creator'

#  Represents Player
class Player
  attr_accessor :name

  def initialize
    @name = nil
    @name_creator = NameCreator.new
    @cell_choice_creator = CellChoiceCreator.new
  end
end
