#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/file/file-creator'

describe FileCreator do
  subject(:file_creator) { described_class.new }
  let(:game) { double('Game') }
  let(:time) { double('Time') }

  describe '#create_file_name' do
    before do
      allow(game).to receive(:current_player_name).and_return('dexter')
      allow(game).to receive(:other_player_name).and_return('mahi')
      allow(time).to receive(:strftime).and_return('20-2-2022-1-1-1')
      file_creator.instance_variable_set(:@time, time)
    end

    it 'creates file name' do
      file_creator.create_file_name(game)
      save_dir = FileCreator::SAVE_DIR
      result = file_creator.instance_variable_get(:@file_name)
      expected_result = "#{save_dir}/dexter-vs-mahi-20-2-2022-1-1-1.yml"
      expect(result).to eq(expected_result)
    end
  end

  describe '#update_last_created_file_name' do
    it 'updates the last created file name with the file name' do
      file_creator.instance_variable_set(:@file_name, 'yml')
      file_creator.update_last_created_file_name
      result = file_creator.instance_variable_get(:@last_created_file_name)
      expect(result).to eq('yml')
    end
  end

  describe '#create_yaml' do
    before { allow(game).to receive(:to_yaml).and_return('yaml') }

    it 'creates yaml' do
      file_creator.create_yaml(game)
      result = file_creator.instance_variable_get(:@yaml)
      expect(result).to eq('yaml')
    end
  end

  describe '#write_to_file' do
    it 'writes to file' do
      file_creator.instance_variable_set(:@file_name, 'yml')
      file_creator.instance_variable_set(:@yaml, 'yaml')
      expect(File).to receive(:write).with('yml', 'yaml')
      file_creator.write_to_file
    end
  end
end
