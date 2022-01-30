#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../components/output/string-color-formatter'

# Command Handler
class Command
  include StringColorFormatter

  def initialize
    @draw_proposal = false
  end

  def draw_proposal?
    @draw_proposal
  end

  def propose_draw(result, player)
    draw_prompt
    choice = make_draw_choice(player)
    update_draw_config(choice, result)
  end

  def make_draw_choice(player)
    return gets.chomp if player.is_a?(Human)

    %w[y n].sample
  end

  def update_draw_config(choice, result)
    return result.update_draw(true) if choice.downcase == 'y'

    update_draw_proposal(false)
  end

  def execute(game, result)
    show_commands
    execute_command(game, result)
    print_spacing
  end

  def execute_command(game, result)
    loop do
      print_command_prompt
      case gets.chomp
      when 'draw' then draw_proposal
      when 'resign' then resign(result, game)
      when 'save' then save(game)
      when 'exit' then break
      end
      print_spacing
    end
  end

  def draw_proposal
    print_info('Draw will be proposed after the completion of this move.')
    update_draw_proposal(true)
  end

  def update_draw_proposal(value)
    @draw_proposal = value
  end

  def resign(result, game)
    result.announce_player_resignation(game)
    exit 0
  end

  def save(_game)
    print 'Saved...'
  end

  private

  def show_commands
    text = "\nCommands: #{accent('draw, resign, save, exit')} (from command mode)"
    print_info(text, ending: "\n")
  end

  def draw_prompt
    print_prompt('Do you want to accept opponent\'s draw proposal? (y/n) > ')
  end

  def print_intro
    print_info("\nCommand Mode: ", ending: "\n")
  end

  def print_command_prompt
    print_prompt('Command > ')
  end

  def print_spacing
    puts "\n\n"
  end
end
