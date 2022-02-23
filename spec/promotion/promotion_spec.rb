#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/promotion/promotion'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe Promotion do
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  let(:promotion_piece_creator) { instance_double(PromotionPieceCreator) }
  let(:piece) { double('PromotedPiece') }
  subject(:promotion) { described_class.new }

  before { fen_processor.process(fen) }

  describe '#promotion?' do
    context 'when the move is a promotion move' do
      let(:fen) { 'P7/1PPPPPPP/3K4/8/3k4/8/1ppppppp/p7 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      context 'when the piece is a pawn' do
        context 'for white color' do
          it 'returns true' do
            destination = :a8
            result = promotion.promotion?(destination, board)
            expect(result).to eq(true)
          end
        end

        context 'for black color' do
          it 'returns true' do
            destination = :a1
            result = promotion.promotion?(destination, board)
            expect(result).to eq(true)
          end
        end
      end

      context 'when the piece is not a pawn' do
        let(:fen) { 'P6K/1PPPPPPP/8/8/8/8/1ppppppp/pk6 w - - 0 1' }
        let(:board) { board_creator.create_board(fen_processor.pieces) }

        context 'for white color' do
          it 'returns false' do
            destination = :h8
            result = promotion.promotion?(destination, board)
            expect(result).to eq(false)
          end
        end

        context 'for black color' do
          it 'returns false' do
            destination = :b1
            result = promotion.promotion?(destination, board)
            expect(result).to eq(false)
          end
        end
      end
    end

    context 'when the move is not a promotion move' do
      let(:fen) { 'P7/1PPPPPPP/3K4/8/3k4/8/1ppppppp/p7 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      context 'when the piece is a pawn' do
        context 'for white color' do
          it 'returns false' do
            destination = :h7
            result = promotion.promotion?(destination, board)
            expect(result).to eq(false)
          end
        end

        context 'for black color' do
          it 'returns false' do
            destination = :d2
            result = promotion.promotion?(destination, board)
            expect(result).to eq(false)
          end
        end
      end

      context 'when the piece is not a pawn' do
        context 'for white color' do
          it 'returns false' do
            destination = :d6
            result = promotion.promotion?(destination, board)
            expect(result).to eq(false)
          end
        end

        context 'for black color' do
          it 'returns false' do
            destination = :d4
            result = promotion.promotion?(destination, board)
            expect(result).to eq(false)
          end
        end
      end
    end
  end

  describe '#promote' do
    before do
      allow(promotion_piece_creator).to receive(:promotion_piece).and_return(piece)
      promotion.instance_variable_set(:@promotion_piece_creator, promotion_piece_creator)
    end

    context 'for white pawn' do
      let(:fen) { 'P6K/1PPPPPPP/8/8/8/8/1ppppppp/pk6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'makes promotion' do
        destination = :a8
        current_color = 'white'
        current_player = nil
        promotion.promote(destination, board, current_color, current_player)
        expect(board[destination].piece).to eq(piece)
      end
    end

    context 'for black pawn' do
      let(:fen) { 'P6K/1PPPPPPP/8/8/8/8/1ppppppp/pk6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'makes promotion' do
        destination = :a1
        current_color = 'black'
        current_player = nil
        promotion.promote(destination, board, current_color, current_player)
        expect(board[destination].piece).to eq(piece)
      end
    end
  end
end
