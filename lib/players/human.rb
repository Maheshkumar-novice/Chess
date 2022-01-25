#!/usr/bin/env ruby
# frozen_string_literal: true

# Represents player Human
class Human
  include StringColorFormatter

  attr_accessor :name

  def initialize(name_creator: NameCreator.new,
                 cell_choice_maker: CellChoiceCreator.new,
                 name_validator: NameValidator.new,
                 cell_choice_validator: CellChoiceValidator.new)
    @name = nil
    @name_creator = name_creator
    @cell_choice_maker = cell_choice_maker
    @name_validator = name_validator
    @cell_choice_validator = cell_choice_validator
  end

  def make_choice
    loop do
      cell_choice = @cell_choice_maker.human_choice
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
