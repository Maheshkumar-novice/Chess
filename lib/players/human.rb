#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './player'
require_relative './utils/name-validator'
require_relative '../cell/utils/cell-choice-validator'
require_relative '../display/string-color-formatter'

# Represents player Human
class Human < Player
  include StringColorFormatter

  def initialize
    super
    @name_validator = NameValidator.new
    @cell_choice_validator = CellChoiceValidator.new
  end

  def make_choice
    loop do
      cell_choice = @cell_choice_creator.human_choice
      return cell_choice if @cell_choice_validator.valid?(cell_choice)

      print_error('Enter a valid choice!', ending: "\n")
    end
  end

  def create_name
    loop do
      @name = @name_creator.human_name
      return if @name_validator.valid?(@name)

      print_error(name_error_text, ending: "\n")
    end
  end

  private

  def name_error_text
    <<~NAME_ERROR
      Enter a valid name! (Min. Length 1, Max. Length #{@name_validator.max_name_length}, No special characters, You can use _, numbers, alphabets)
    NAME_ERROR
  end
end
