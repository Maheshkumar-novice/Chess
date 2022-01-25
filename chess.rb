#!/usr/bin/env ruby
# frozen_string_literal: true

Dir['./lib/board/**/*.rb'].sort.each { |file| require file }
Dir['./lib/chess-game/**/*.rb'].sort.each { |file| require file }
Dir['./lib/components/**/*.rb'].sort.each { |file| require file }
Dir['./lib/pieces/**/*.rb'].sort.each { |file| require file }
Dir['./lib/players/**/*.rb'].sort.each { |file| require file }
