#!/usr/bin/env ruby
# frozen_string_literal: true

require 'psych'
require_relative '../components/output/string-color-formatter'

# File Loader Class
class FileLoader
  SAVE_DIR = 'saved_games'

  include StringColorFormatter

  def initialize
    @files = nil
    @files_hash = {}
    @user_input = nil
  end

  def load
    create_saved_games_dir unless Dir.exist?('saved_games')
    return if saved_games_empty?

    list_saves
    load_file
  end

  def saved_games_empty?
    Dir.empty?('saved_games')
  end

  def list_saves
    @files = Dir.glob('saved_games/*.yml')
    create_hash_of_files
    print_files
  end

  def load_file
    loop do
      user_input
      return yaml_load if valid_input?
    end
  end

  def user_input
    print_prompt('Enter number of the file to load >', ending: ' ')
    @user_input = gets.chomp
  end

  def valid_input?
    @files_hash.key?(@user_input)
  end

  def yaml_load
    Psych.load_file(@files_hash[@user_input])
  end

  def create_saved_games_dir
    Dir.mkdir('saved_games')
  end

  def create_hash_of_files
    @files_hash = @files.map.with_index(1) { |file, index| [index.to_s, file] }.to_h
  end

  def print_files
    print_info('Available Saves:', starting: "\n", ending: "\n")
    @files_hash.each do |key, value|
      puts "#{accent(key)}: #{value}"
    end
    puts
  end
end
