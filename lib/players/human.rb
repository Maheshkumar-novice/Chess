#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './player'

# Human Player
class Human < Player
  def input
    gets.chomp
  end

  def create_name
    @name = name_input until valid_name?(@name.to_s)
  end

  private

  def name_input
    print 'Enter Your Name > '
    @name = gets.chomp
  end
end
