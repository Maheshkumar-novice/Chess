#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/fen'

describe Fen do
  subject(:fen) { described_class.new }
  let(:piece) { instance_double(Piece) }
end
