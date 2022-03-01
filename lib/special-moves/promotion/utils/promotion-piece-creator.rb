#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../pieces/queen'
require_relative '../../pieces/rook'
require_relative '../../pieces/bishop'
require_relative '../../pieces/knight'
require_relative '../../display/string-color-formatter'

# Promotion piece creator
class PromotionPieceCreator
  include StringColorFormatter

  def promotion_piece(destination, current_color, current_player)
    create_piece(player_piece_choice(current_player), destination, current_color)
  end

  def create_piece(choice, destination, current_color)
    piece = piece(choice)
    piece.name = current_color == 'white' ? choice.upcase : choice
    piece.current_cell = destination
    piece.color = current_color
    piece
  end

  def piece(choice)
    case choice
    when 'q' then Queen.new
    when 'r' then Rook.new
    when 'b' then Bishop.new
    when 'n' then Knight.new
    end
  end

  def player_piece_choice(current_player)
    return %w[q r b n].sample if current_player.is_a?(Bot)

    human_player_choice
  end

  def human_player_choice
    print_promotions_available
    loop do
      choice = choice_input
      return choice if valid_choice?(choice)

      print_error('Enter a valid option!', ending: "\n")
    end
  end

  def valid_choice?(choice)
    choice.match?(/^[qrbn]{1}$/)
  end

  private

  def print_promotions_available
    str = <<~PROMOTIONS
      #{print_info(accent('Promotions Available: '), ending: "\n", starting: "\n")}
        q. Queen
        r. Rook
        b. Bishop
        n. Knight

    PROMOTIONS
    print_info(str, ending: "\n")
  end

  def choice_input
    print_prompt('Enter Your Option [q, r, b, n] > ')
    $stdin.gets.chomp
  end
end
