#!/usr/bin/env ruby
# frozen_string_literal: true

# Name Validator
class NameValidator
  attr_reader :max_name_length

  def initialize
    @max_name_length = 25
  end

  def valid?(name)
    name.match?(/^[\w+\s]{1,#{@max_name_length}}$/)
  end
end
