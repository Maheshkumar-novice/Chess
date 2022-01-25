#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents player Human
class Human < Player
  include StringColorFormatter

  def initialize(name_creator: NameCreator.new,
                 cell_choice_creator: CellChoiceCreator.new,
                 name_validator: NameValidator.new,
                 cell_choice_validator: CellChoiceValidator.new)
    super(name_creator, cell_choice_creator)
    @name_validator = name_validator
    @cell_choice_validator = cell_choice_validator
  end

  def make_choice
    loop do
      cell_choice = @cell_choice_creator.human_choice
      return cell_choice if @cell_choice_validator.valid?(cell_choice)

      print_error('Enter a valid cell coordinate!', ending: "\n")
    end
  end

  def create_name
    loop do
      @name = @name_creator.human_name
      return if @name_validator.valid?(@name)

      print_error(
        "Enter a valid name! (Min. Length 1, Max. Length #{@name_validator.max_name_length}, No special characters)",
        ending: "\n"
      )
    end
  end
end
