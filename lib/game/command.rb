#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../display/string-color-formatter'
require_relative '../yaml/yaml-creator'

# Command Handler
class Command
  include StringColorFormatter

  attr_reader :draw_approval_status, :draw_proposal_status, :draw_proposer_color

  def initialize
    @yaml_creator = YAMLCreator.new
    @draw_proposal_status = false
    @draw_proposer_color = nil
    @draw_approval_status = false
  end

  def propose_draw(player, color)
    return unless @draw_proposal_status
    return if @draw_proposer_color == color

    draw_prompt
    update_draw_approval_status(player_choice_for_draw_approval(player))
    update_draw_proposal_status(false)
    update_draw_proposer_color(nil)
  end

  def execute(game, result)
    print_intro
    show_commands
    execute_command(game, result)
    print_spacing
  end

  def create_draw_proposal(game)
    print_info('Draw will be proposed after the completion of your current move.', ending: "\n")
    update_draw_proposal_status(true)
    update_draw_proposer_color(game.current_color)
  end

  def resign(result, game)
    result.update_resign(true)
    result.announce(game)
    exit 0
  end

  def save(game)
    @yaml_creator.save(game)
    print_file_created_message
  end

  def fen(game)
    board = game.board_operator.to_s
    color = game.current_color == 'white' ? 'w' : 'b'
    meta_data = game.meta_data.to_s
    counter = game.counters.to_s
    print_info("#{board} #{color} #{meta_data} #{counter}", ending: "\n\n")
  end

  private

  def execute_command(game, result)
    loop do
      print_command_prompt
      case $stdin.gets.chomp
      when 'draw' then create_draw_proposal(game)
      when 'resign' then resign(result, game)
      when 'save' then save(game)
      when 'fen' then fen(game)
      when 'exit' then break
      end
    end
  end

  def player_choice_for_draw_approval(player)
    player.is_a?(Human) ? $stdin.gets.chomp : %w[y n].sample
  end

  def update_draw_approval_status(choice)
    @draw_approval_status = choice.downcase == 'y'
  end

  def update_draw_proposal_status(value)
    @draw_proposal_status = value
  end

  def update_draw_proposer_color(value)
    @draw_proposer_color = value
  end

  def show_commands
    text = "Commands: #{accent('draw, resign, save, fen, exit')} (from command mode)"
    print_info(text, ending: "\n", starting: "\n")
  end

  def draw_prompt
    print_prompt('Do you want to accept opponent\'s draw proposal? (y/n) > ')
  end

  def print_intro
    print_info('Command Mode: ', starting: "\n")
  end

  def print_command_prompt
    print_prompt('Command > ')
  end

  def print_file_created_message
    text = "File saved as #{accent(@yaml_creator.last_created_file_name)} successfully!"
    print_info(text, ending: "\n")
  end

  def print_spacing
    print "\n"
  end
end
