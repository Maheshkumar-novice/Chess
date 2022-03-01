#!/usr/bin/env ruby
# frozen_string_literal: true

# Validates the given name
class NameValidator
  attr_reader :max_name_length

  def initialize
    @max_name_length = 25
  end

  def valid?(name)
    name.match?(/^\w+{1,#{@max_name_length}}$/)
  end
end
