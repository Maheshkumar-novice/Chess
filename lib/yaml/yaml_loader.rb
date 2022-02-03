#!/usr/bin/env ruby
# frozen_string_literal: true

require 'psych'
require_relative '../display/string-color-formatter'

# YAML Loader Class
class YAMLLoader
  SAVE_DIR = 'saved-games'

  include StringColorFormatter

  def initialize
    @files = nil
    @files_hash = {}
    @user_input = nil
  end

  def load
    create_saved_games_dir unless Dir.exist?(SAVE_DIR)
    return if saved_games_empty?

    list_saves
    load_file
  end

  def create_saved_games_dir
    Dir.mkdir(SAVE_DIR)
  end

  def saved_games_empty?
    Dir.empty?(SAVE_DIR)
  end

  def list_saves
    @files = Dir.glob("#{SAVE_DIR}/*.yml")
    create_hash_of_files
    print_files
  end

  def create_hash_of_files
    @files_hash = @files.map.with_index(1) { |file, index| [index.to_s, file] }.to_h
  end

  def load_file
    loop do
      @user_input = user_input
      return yaml_load if valid_input?

      print_invalid_input
    end
  end

  def valid_input?
    @files_hash.key?(@user_input)
  end

  def yaml_load
    Psych.load_file(@files_hash[@user_input])
  end

  private

  def user_input
    print_prompt('Enter number of the file to load >', ending: ' ')
    gets.chomp
  end

  def print_invalid_input
    print_error('Invalid Input! Select a correct number (e.g. 1)', ending: "\n")
  end

  def print_files
    print_info('Available Saves:', starting: "\n", ending: "\n")
    @files_hash.each do |key, value|
      puts "#{accent(key)}: #{value}"
    end
    puts
  end
end
