#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './player'

# Represents player Bot
class Bot < Player
  def make_choice
    @cell_choice_creator.bot_choice
  end

  def create_name
    @name = @name_creator.bot_name
  end
end
