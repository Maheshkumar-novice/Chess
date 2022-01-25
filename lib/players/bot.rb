#!/usr/bin/env ruby
# frozen_string_literal: true

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
