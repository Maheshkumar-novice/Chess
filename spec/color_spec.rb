#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/utils/color.rb'

describe String do
  describe '#colorize' do
    let(:string) { 'hello' }

    it 'converts the string to black color' do
      expect(string.black).to eq("\e[30m#{string}\e[0m")
    end

    it 'converts the string to red color' do
      expect(string.red).to eq("\e[31m#{string}\e[0m")
    end

    it 'converts the string to green color' do
      expect(string.green).to eq("\e[32m#{string}\e[0m")
    end

    it 'converts the string to yellow color' do
      expect(string.yellow).to eq("\e[33m#{string}\e[0m")
    end

    it 'converts the string to blue color' do
      expect(string.blue).to eq("\e[34m#{string}\e[0m")
    end

    it 'converts the string to magenta color' do
      expect(string.magenta).to eq("\e[35m#{string}\e[0m")
    end

    it 'converts color to cyan color' do
      expect(string.cyan).to eq("\e[36m#{string}\e[0m")
    end

    it 'converts color to gray color' do
      expect(string.gray).to eq("\e[37m#{string}\e[0m")
    end

    it 'converts the string bg to black' do
      expect(string.bg_black).to eq("\e[40m#{string}\e[0m")
    end

    it 'converts the string bg to red' do
      expect(string.bg_red).to eq("\e[41m#{string}\e[0m")
    end

    it 'converts the string bg to green' do
      expect(string.bg_green).to eq("\e[42m#{string}\e[0m")
    end

    it 'converts the string bg to yellow' do
      expect(string.bg_yellow).to eq("\e[43m#{string}\e[0m")
    end

    it 'converts the string bg to blue' do
      expect(string.bg_blue).to eq("\e[44m#{string}\e[0m")
    end

    it 'converts the string bg to magenta' do
      expect(string.bg_magenta).to eq("\e[45m#{string}\e[0m")
    end

    it 'converts the string bg to cyan' do
      expect(string.bg_cyan).to eq("\e[46m#{string}\e[0m")
    end

    it 'converts the string bg to gray' do
      expect(string.bg_gray).to eq("\e[47m#{string}\e[0m")
    end

    it 'converts the string to bold' do
      expect(string.bold).to eq("\e[1m#{string}\e[22m")
    end

    it 'converts the string to italic' do
      expect(string.italic).to eq("\e[3m#{string}\e[23m")
    end

    it 'underlines the string' do
      expect(string.underline).to eq("\e[4m#{string}\e[24m")
    end

    it 'reverts color and bg of the string' do
      expect(string.reverse_color).to eq("\e[7m#{string}\e[27m")
    end
  end
end
