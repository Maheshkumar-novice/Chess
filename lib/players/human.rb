#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './player'

# Human Player
class Human < Player
  def input
    gets.chomp.to_sym
  end
end
