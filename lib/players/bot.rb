#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './player'
require_relative '../components/creators/name-creator'
require_relative '../components/creators/cell-choice-creator'

# Represents player Bot
class Bot < Player
  def initialize(name_creator: NameCreator.new, cell_choice_creator: CellChoiceCreator.new)
    super(name_creator, cell_choice_creator)
  end

  def make_choice
    @cell_choice_creator.bot_choice
  end

  def create_name
    @name = @name_creator.bot_name
  end
end
