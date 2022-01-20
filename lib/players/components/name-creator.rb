#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../utils/display'

# Name Creator
class NameCreator
  include Display

  def bot_name
    %w[nick fury rick morty].sample
  end

  def human_name
    print_prompt('Enter Your Name > ')
    gets.chomp
  end
end
