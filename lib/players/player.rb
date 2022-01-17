#!/usr/bin/env ruby
# frozen_string_literal: true

# Player Class
class Player
  attr_accessor :name, :color

  MAX_NAME_LENGTH = 15

  def initialize
    @name = nil
    @color = nil
  end

  def input; end

  def create_name; end

  def valid_name?(name)
    name.match?(/^[\w+\s]{1,#{MAX_NAME_LENGTH}}$/)
  end
end
