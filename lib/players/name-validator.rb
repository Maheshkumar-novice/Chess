#!/usr/bin/env ruby
# frozen_string_literal: true

# Name Validator
class NameValidator
  def valid?(name)
    name.match?(/^[\w+\s]{1,25}$/)
  end
end
