#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/yaml/yaml_loader'

describe YAMLLoader do
  subject(:yaml_loader) { described_class.new }

  describe '#saved_games_empty?' do
    it 'sends :empty? message to Dir' do
      expect(Dir).to receive(:empty?).with(YAMLLoader::SAVE_DIR)
      yaml_loader.saved_games_empty?
    end
  end

  describe '#list_saves' do
    before do
      allow(yaml_loader).to receive(:create_hash_of_files)
      allow(yaml_loader).to receive(:print_files)
    end

    it 'sends :glob message to Dir' do
      expect(Dir).to receive(:glob).with("#{YAMLLoader::SAVE_DIR}/*.yml")
      yaml_loader.list_saves
    end
  end

  describe '#load_file' do
    before do
      allow(yaml_loader).to receive(:yaml_load)
      allow(yaml_loader).to receive(:print_invalid_input)
      yaml_loader.instance_variable_set(:@files_hash, { '1' => '', '2' => '' })
    end

    context 'when user input is valid' do
      before { allow(yaml_loader).to receive(:user_input).and_return('1') }

      it 'calls user_input once' do
        expect(yaml_loader).to receive(:user_input)
        yaml_loader.load_file
      end
    end

    context 'when user input is invalid and then valid' do
      before { allow(yaml_loader).to receive(:user_input).and_return('3', '1') }

      it 'calls user_input twice' do
        expect(yaml_loader).to receive(:user_input).twice
        yaml_loader.load_file
      end
    end

    context 'when user input is invalid, invalid and then valid' do
      before { allow(yaml_loader).to receive(:user_input).and_return('3', '4', '2') }

      it 'calls user_input three times' do
        expect(yaml_loader).to receive(:user_input).exactly(3).times
        yaml_loader.load_file
      end
    end
  end

  describe '#valid_input?' do
    before { yaml_loader.instance_variable_set(:@files_hash, { '1' => '', '2' => '' }) }

    context 'when the user input is valid' do
      before { yaml_loader.instance_variable_set(:@user_input, '1') }

      it 'returns true' do
        result = yaml_loader.valid_input?
        expect(result).to eq(true)
      end
    end

    context 'when the user input is invalid' do
      before { yaml_loader.instance_variable_set(:@user_input, '3') }

      it 'returns false' do
        result = yaml_loader.valid_input?
        expect(result).to eq(false)
      end
    end
  end

  describe '#yaml_load' do
    it 'sends :load_file message to Psych' do
      expect(Psych).to receive(:load_file)
      yaml_loader.yaml_load
    end
  end

  describe '#create_saved_games_dir' do
    it 'sends :mkdir message to Dir' do
      expect(Dir).to receive(:mkdir).with(YAMLLoader::SAVE_DIR)
      yaml_loader.create_saved_games_dir
    end
  end

  describe '#create_hash_of_files' do
    before { yaml_loader.instance_variable_set(:@files, %w[a b]) }

    it 'creates files hash' do
      yaml_loader.create_hash_of_files
      result = yaml_loader.instance_variable_get(:@files_hash)
      expected_result = { '1' => 'a', '2' => 'b' }
      expect(result).to eq(expected_result)
    end
  end
end
