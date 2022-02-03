#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/file/file-loader'

describe FileLoader do
  subject(:file_loader) { described_class.new }

  describe '#saved_games_empty?' do
    it 'sends :empty? message to Dir' do
      expect(Dir).to receive(:empty?).with(FileLoader::SAVE_DIR)
      file_loader.saved_games_empty?
    end
  end

  describe '#list_saves' do
    before do
      allow(file_loader).to receive(:create_hash_of_files)
      allow(file_loader).to receive(:print_files)
    end

    it 'sends :glob message to Dir' do
      expect(Dir).to receive(:glob).with("#{FileLoader::SAVE_DIR}/*.yml")
      file_loader.list_saves
    end
  end

  describe '#load_file' do
    before do
      allow(file_loader).to receive(:yaml_load)
      allow(file_loader).to receive(:print_invalid_input)
      file_loader.instance_variable_set(:@files_hash, { '1' => '', '2' => '' })
    end

    context 'when user input is valid' do
      before { allow(file_loader).to receive(:user_input).and_return('1') }

      it 'calls user_input once' do
        expect(file_loader).to receive(:user_input)
        file_loader.load_file
      end
    end

    context 'when user input is invalid and then valid' do
      before { allow(file_loader).to receive(:user_input).and_return('3', '1') }

      it 'calls user_input twice' do
        expect(file_loader).to receive(:user_input).twice
        file_loader.load_file
      end
    end

    context 'when user input is invalid, invalid and then valid' do
      before { allow(file_loader).to receive(:user_input).and_return('3', '4', '2') }

      it 'calls user_input three times' do
        expect(file_loader).to receive(:user_input).exactly(3).times
        file_loader.load_file
      end
    end
  end

  describe '#valid_input?' do
    before { file_loader.instance_variable_set(:@files_hash, { '1' => '', '2' => '' }) }

    context 'when the user input is valid' do
      before { file_loader.instance_variable_set(:@user_input, '1') }

      it 'returns true' do
        result = file_loader.valid_input?
        expect(result).to eq(true)
      end
    end

    context 'when the user input is invalid' do
      before { file_loader.instance_variable_set(:@user_input, '3') }

      it 'returns false' do
        result = file_loader.valid_input?
        expect(result).to eq(false)
      end
    end
  end

  describe '#yaml_load' do
    it 'sends :load_file message to Psych' do
      expect(Psych).to receive(:load_file)
      file_loader.yaml_load
    end
  end

  describe '#create_saved_games_dir' do
    it 'sends :mkdir message to Dir' do
      expect(Dir).to receive(:mkdir).with(FileLoader::SAVE_DIR)
      file_loader.create_saved_games_dir
    end
  end

  describe '#create_hash_of_files' do
    before { file_loader.instance_variable_set(:@files, %w[a b]) }

    it 'creates files hash' do
      file_loader.create_hash_of_files
      result = file_loader.instance_variable_get(:@files_hash)
      expected_result = { '1' => 'a', '2' => 'b' }
      expect(result).to eq(expected_result)
    end
  end
end
