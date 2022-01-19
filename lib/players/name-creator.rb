#!/usr/bin/env ruby
# frozen_string_literal: true

# Name Creator
class NameCreator
  def bot_name
    %w[nick fury rick morty].sample
  end

  def human_name
    print 'Enter Your Name > '
    gets.chomp
  end
end
