#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../display/string-color-formatter'

# Creates names
class NameCreator
  include StringColorFormatter

  def bot_name
    %w[nick fury rick morty].sample
  end

  def human_name
    print_prompt('Enter Your Name > ')
    $stdin.gets.chomp
  end
end
