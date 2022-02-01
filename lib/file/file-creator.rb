#!/usr/bin/env ruby
# frozen_string_literal: true

require 'psych'

# File Creator Class
class FileCreator
  SAVE_DIR = 'saved_games'

  attr_reader :last_created_file_name

  def initialize
    @last_created_file_name = nil
    @file_name = nil
    @yaml = nil
  end

  def save(game)
    create_file_name(game)
    update_last_created_file_name
    create_yaml(game)
    write_to_file
  end

  def create_file_name(game)
    player_data = "#{game.current_player.name}-vs-#{game.other_player.name}"
    datetime = Time.new.strftime('%d-%m-%Y-%k-%M-%S')
    @file_name = "#{SAVE_DIR}/#{player_data}-#{datetime}.yml"
  end

  def update_last_created_file_name
    @last_created_file_name = @file_name
  end

  def create_yaml(game)
    @yaml = game.to_yaml
  end

  def write_to_file
    File.write(@file_name, @yaml)
  end
end
