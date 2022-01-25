#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents player Bot
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
