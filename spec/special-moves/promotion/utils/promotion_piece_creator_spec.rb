#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../../lib/special-moves/promotion/utils/promotion-piece-creator'
require_relative '../../../../lib/players/bot'

describe PromotionPieceCreator do
  subject(:promotion_piece_creator) { described_class.new }
  let(:current_player) { double('Player') }

  describe '#create_piece' do
    it 'returns a piece' do
      choice = 'r'
      destination = :a8
      current_color = 'white'
      result = promotion_piece_creator.create_piece(choice, destination, current_color)
      expect(result).to be_a(Piece)
    end

    it 'returns a piece with the current cell attribute' do
      choice = 'r'
      destination = :a8
      current_color = 'white'
      result = promotion_piece_creator.create_piece(choice, destination, current_color)
      expect(result.current_cell).to eq(:a8)
    end

    it 'returns a piece with the color attribute' do
      choice = 'r'
      destination = :a8
      current_color = 'white'
      result = promotion_piece_creator.create_piece(choice, destination, current_color)
      expect(result.color).to eq('white')
    end

    context 'for white piece' do
      it 'returns a piece with capital case name attribute' do
        choice = 'r'
        destination = :a8
        current_color = 'white'
        result = promotion_piece_creator.create_piece(choice, destination, current_color)
        expect(result.name).to eq('R')
      end
    end

    context 'for black piece' do
      it 'returns a piece with small case name attribute' do
        choice = 'r'
        destination = :a8
        current_color = 'black'
        result = promotion_piece_creator.create_piece(choice, destination, current_color)
        expect(result.name).to eq('r')
      end
    end
  end

  describe '#piece' do
    context 'for choice q' do
      it 'returns queen' do
        result = promotion_piece_creator.piece('q')
        expect(result).to be_a(Queen)
      end
    end

    context 'for choice r' do
      it 'returns rook' do
        result = promotion_piece_creator.piece('r')
        expect(result).to be_a(Rook)
      end
    end

    context 'for choice b' do
      it 'returns bishop' do
        result = promotion_piece_creator.piece('b')
        expect(result).to be_a(Bishop)
      end
    end

    context 'for choice n' do
      it 'returns knight' do
        result = promotion_piece_creator.piece('n')
        expect(result).to be_a(Knight)
      end
    end
  end

  describe '#player_piece_choice' do
    context 'for bot player' do
      before { allow(current_player).to receive(:is_a?).with(Bot).and_return(true) }

      it 'returns a random piece choice' do
        result = promotion_piece_creator.player_piece_choice(current_player)
        expect(%w[q r b n].include?(result)).to eq(true)
      end
    end

    context 'for human player' do
      before { allow(current_player).to receive(:is_a?).and_return(false) }

      it 'calls human_player_choice' do
        expect(promotion_piece_creator).to receive(:human_player_choice)
        promotion_piece_creator.player_piece_choice(current_player)
      end
    end
  end

  describe '#human_player_choice' do
    before do
      allow(promotion_piece_creator).to receive(:print_promotions_available)
      allow(promotion_piece_creator).to receive(:print_error)
    end

    context 'when user enters a valid choice' do
      before do
        valid_choice = 'q'
        allow(promotion_piece_creator).to receive(:choice_input).and_return(valid_choice)
      end

      it 'calls choice_input once' do
        expect(promotion_piece_creator).to receive(:choice_input).once
        promotion_piece_creator.human_player_choice
      end

      it 'returns the valid choice' do
        result = promotion_piece_creator.human_player_choice
        expect(result).to eq('q')
      end
    end

    context 'when user enters an invalid choice once than a valid choice' do
      before do
        invalid_choice = 'a'
        valid_choice = 'r'
        allow(promotion_piece_creator).to receive(:choice_input).and_return(invalid_choice, valid_choice)
      end

      it 'calls choice_input twice' do
        expect(promotion_piece_creator).to receive(:choice_input).twice
        promotion_piece_creator.human_player_choice
      end

      it 'returns the valid choice' do
        result = promotion_piece_creator.human_player_choice
        expect(result).to eq('r')
      end
    end

    context 'when user enters an invalid choice twice than a valid choice' do
      before do
        invalid_choice1 = 'z'
        invalid_choice2 = 'x'
        valid_choice = 'n'
        allow(promotion_piece_creator).to receive(:choice_input).and_return(invalid_choice1, invalid_choice2, valid_choice)
      end

      it 'calls choice_input three times' do
        expect(promotion_piece_creator).to receive(:choice_input).exactly(3).times
        promotion_piece_creator.human_player_choice
      end

      it 'returns the valid choice' do
        result = promotion_piece_creator.human_player_choice
        expect(result).to eq('n')
      end
    end
  end

  describe '#valid_choice?' do
    context 'for invalid choice' do
      context 'for single letter choice' do
        it 'returns false' do
          choice = (('a'..'z').to_a - %w[q r b n]).sample
          result = promotion_piece_creator.valid_choice?(choice)
          expect(result).to eq(false)
        end
      end

      context 'for two letter choice' do
        it 'returns false' do
          choice = 'bz'
          result = promotion_piece_creator.valid_choice?(choice)
          expect(result).to eq(false)
        end
      end

      context 'for three letter choice' do
        it 'returns false' do
          choice = 'ant'
          result = promotion_piece_creator.valid_choice?(choice)
          expect(result).to eq(false)
        end
      end
    end

    context 'for valid choice' do
      it 'returns true' do
        choice = %w[q r b n].sample
        result = promotion_piece_creator.valid_choice?(choice)
        expect(result).to eq(true)
      end
    end
  end
end
