#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/yaml/yaml-creator'

describe YAMLCreator do
  subject(:yaml_creator) { described_class.new }
  let(:game) { double('Game') }

  describe '#create_file_name' do
    before do
      allow(game).to receive(:current_player_name).and_return('dexter')
      allow(game).to receive(:other_player_name).and_return('mahi')
    end

    it 'creates file name' do
      yaml_creator.create_file_name(game)
      save_dir = YAMLCreator::SAVE_DIR
      result = yaml_creator.instance_variable_get(:@file_name)
      expected_result = result.match?(%r{#{save_dir}/.+\.yml})
      expect(expected_result).to eq(true)
    end
  end

  describe '#update_last_created_file_name' do
    it 'updates the last created file name with the file name' do
      yaml_creator.instance_variable_set(:@file_name, 'yml')
      yaml_creator.update_last_created_file_name
      result = yaml_creator.instance_variable_get(:@last_created_file_name)
      expect(result).to eq('yml')
    end
  end

  describe '#create_yaml' do
    before { allow(game).to receive(:to_yaml).and_return('yaml') }

    it 'creates yaml' do
      yaml_creator.create_yaml(game)
      result = yaml_creator.instance_variable_get(:@yaml)
      expect(result).to eq('yaml')
    end
  end

  describe '#write_to_file' do
    it 'writes to file' do
      yaml_creator.instance_variable_set(:@file_name, 'yml')
      yaml_creator.instance_variable_set(:@yaml, 'yaml')
      expect(File).to receive(:write).with('yml', 'yaml')
      yaml_creator.write_to_file
    end
  end
end
