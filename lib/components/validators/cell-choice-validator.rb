#!/usr/bin/env ruby
# frozen_string_literal: true

# Cell Choice Validator
class CellChoiceValidator
  def valid?(cell_choice)
    cell_choice.match?(/^[a-h][1-8]$/)
  end
end
