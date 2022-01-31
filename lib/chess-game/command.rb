#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../components/output/string-color-formatter'

# Command Handler
class Command
  include StringColorFormatter

  attr_reader :draw_approval_status

  def initialize
    @draw_proposal_status = false
    @draw_approval_status = false
  end

  def propose_draw(player)
    return unless @draw_proposal_status

    draw_prompt
    update_draw_approval_status(player_choice_for_draw_approval(player))
    update_draw_proposal_status(false)
  end

  def player_choice_for_draw_approval(player)
    return gets.chomp if player.is_a?(Human)

    %w[y n].sample
  end

  def update_draw_approval_status(choice)
    @draw_approval_status = choice.downcase == 'y'
  end

  def update_draw_proposal_status(value)
    @draw_proposal_status = value
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
      when 'draw' then create_draw_proposal
      when 'resign' then resign(result, game)
      when 'save' then save(game)
      when 'exit' then break
      end
      print_spacing
    end
  end

  def create_draw_proposal
    print_info('Draw will be proposed after the completion of your current move.')
    update_draw_proposal_status(true)
  end

  def resign(result, game)
    result.update_resign(true)
    result.announce(game)
    exit 0
  end

  def save(_game)
    print 'Saved...'
  end

  private

  def show_commands
    text = "Commands: #{accent('draw, resign, save, exit')} (from command mode)"
    print_info(text, ending: "\n", starting: "\n")
  end

  def draw_prompt
    print_prompt('Do you want to accept opponent\'s draw proposal? (y/n) > ')
  end

  def print_intro
    print_info('Command Mode: ', ending: "\n", starting: "\n")
  end

  def print_command_prompt
    print_prompt('Command > ')
  end

  def print_spacing
    puts "\n\n"
  end
end
