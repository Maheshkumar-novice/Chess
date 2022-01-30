#!/usr/bin/env ruby
# frozen_string_literal: true

# Validates the given cell choice
class CellChoiceValidator
  def valid?(cell_choice)
    cell_choice.match?(/^[a-h][1-8]$|^cmd$/)
  end
end
