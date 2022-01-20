#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './components/name-creator'
require_relative './components/name-validator'
require_relative './components/cell-choice-maker'
require_relative './components/cell-choice-validator'
require_relative '../utils/display'

# Human Player
class Human
  include Display

  attr_accessor :name, :color

  def initialize(name_creator: NameCreator.new,
                 cell_choice_maker: CellChoiceMaker.new,
                 name_validator: NameValidator.new,
                 cell_choice_validator: CellChoiceValidator.new)
    @name = nil
    @color = nil
    @name_creator = name_creator
    @cell_choice_maker = cell_choice_maker
    @name_validator = name_validator
    @cell_choice_validator = cell_choice_validator
  end

  def make_choice
    cell_choice = @cell_choice_maker.human_choice
    until @cell_choice_validator.valid?(cell_choice)
      print_error('Enter a valid cell coordinate!', ending: "\n")
      cell_choice = @cell_choice_maker.human_choice
    end
    cell_choice
  end

  def create_name
    @name = @name_creator.human_name
    until @name_validator.valid?(@name)
      print_error(
        "Enter a valid name! (Min. Length 1, Max. Length #{@name_validator.max_name_length}, No special characters)",
        ending: "\n"
      )
      @name = @name_creator.human_name
    end
  end
end
