#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../components/creators/name-creator'
require_relative '../components/creators/cell-choice-creator'

# Bot Player
class Bot
  attr_accessor :name

  def initialize(name_creator: NameCreator.new, cell_choice_maker: CellChoiceCreator.new)
    @name = nil
    @name_creator = name_creator
    @cell_choice_maker = cell_choice_maker
  end

  def make_choice
    @cell_choice_maker.bot_choice
  end

  def create_name
    @name = @name_creator.bot_name
  end
end
