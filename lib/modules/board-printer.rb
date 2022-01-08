#!/usr/bin/env ruby
# frozen_string_literal: true

# Board Printer
module BoardPrinter
  def template(value)
    value = ' ' if value.nil?

    <<~T
      | #{value}#{' '}
    T
  end

  def print_board
    print_column_info
    print_remaining_board
    print_column_info
  end

  def print_column_info
    print '  '
    ('a'..'h').each do |value|
      print "  #{value} "
    end
  end

  def print_remaining_board
    row_no = 1
    print_before_first_row(row_no)
    @board.each do |key, value|
      print_cell(value)
      next unless key.match?(/h/)

      print_after_row_end(row_no)
      row_no += 1
      print "#{row_no} " if row_no <= 8
    end
  end

  def print_before_first_row(row_no)
    puts "\n  ---------------------------------"
    print "#{row_no} "
  end

  def print_cell(value)
    template(value.piece&.name).to_s.chomp
  end

  def print_after_row_end(row_no)
    print '|'
    print " #{row_no}"
    puts "\n  ---------------------------------"
  end
end
