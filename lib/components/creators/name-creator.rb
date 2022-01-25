#!/usr/bin/env ruby
# frozen_string_literal: true

# Creates names
class NameCreator
  include StringColorFormatter

  def bot_name
    %w[nick fury rick morty].sample
  end

  def human_name
    print_prompt('Enter Your Name > ')
    gets.chomp
  end
end
