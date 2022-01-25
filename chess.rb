#!/usr/bin/env ruby
# frozen_string_literal: true

require 'forwardable'

Dir['./lib/components/output/*.rb'].sort.each { |file| require file }
Dir['./lib/components/creators/*.rb'].sort.each { |file| require file }
Dir['./lib/components/validators/*.rb'].sort.each { |file| require file }
Dir['./lib/components/helpers/*.rb'].sort.each { |file| require file }
Dir['./lib/board/*.rb'].sort.each { |file| require file }
Dir['./lib/pieces/piece.rb'].sort.each { |file| require file }
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }
Dir['./lib/players/*.rb'].sort.each { |file| require file }
Dir['./lib/chess-game/*.rb'].sort.each { |file| require file }
