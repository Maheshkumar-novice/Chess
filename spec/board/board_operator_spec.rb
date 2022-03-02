#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/board/board-operator'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe BoardOperator do
  subject(:board_operator) { described_class.new(board, meta_data) }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  let(:board) { board_creator.create_board(fen_processor.pieces) }
  let(:meta_data) { fen_processor.meta_data }
  before { fen_processor.process(fen) }

  describe '#make_move' do
    context 'when tried to make a regular move' do
      let(:fen) { 'rn1qkbnr/p2p1p1p/2P3p1/4p3/P6B/1P6/3QPPPP/RN2KBNR w KQkq - 0 1' }

      before do
        allow(meta_data).to receive(:special_moves_state).and_return({})
      end

      it 'makes the move' do
        source = :d2
        destination = :d7
        previous_source_piece = board[source].piece
        board_operator.make_move(source, destination)
        current_source_piece = board[source].piece
        current_destinatin_piece = board[destination].piece
        expect(current_source_piece).to be_nil
        expect(current_destinatin_piece).to eq(previous_source_piece)
      end
    end

    context 'when tried to make an en_passant move' do
      let(:fen) { 'rn1qkbnr/p4p1p/6p1/2Ppp3/P6B/1P6/3QPPPP/RN2KBNR w KQkq d6 0 1' }

      before do
        allow(meta_data).to receive(:special_moves_state).and_return({ en_passant: true })
      end

      it 'makes the move' do
        source = :c5
        destination = :d6
        en_passant_piece_cell = :d5
        previous_source_piece = board[source].piece
        board_operator.make_move(source, destination)
        current_source_piece = board[source].piece
        current_destinatin_piece = board[destination].piece
        current_en_passant_piece = board[en_passant_piece_cell].piece
        expect(current_source_piece).to be_nil
        expect(current_destinatin_piece).to eq(previous_source_piece)
        expect(current_en_passant_piece).to eq(nil)
      end
    end

    context 'when the move creates en_passant possibility' do
      let(:fen) { 'rn1qkbnr/p2p1p1p/6p1/2P1p3/P6B/1P6/3QPPPP/RN2KBNR w KQkq d6 0 1' }

      before do
        allow(meta_data).to receive(:special_moves_state).and_return({ en_passant: false })
      end

      it 'updates en_passant cell to a cell marker' do
        source = :d7
        destination = :d5
        board_operator.make_move(source, destination)
        result = meta_data.en_passant_move
        expect(result).to eq(:d6)
      end
    end

    context 'when the move doesn\'t create en_passant possibility' do
      let(:fen) { 'rn1qkbnr/p2p1p1p/6p1/2P1p3/P6B/1P6/3QPPPP/RN2KBNR w KQkq d6 0 1' }

      before do
        allow(meta_data).to receive(:special_moves_state).and_return({ en_passant: true })
      end

      it 'updates en_passant cell to be not a cell marker' do
        source = :f2
        destination = :f3
        board_operator.make_move(source, destination)
        result = meta_data.en_passant_move
        expect(result).to eq(:-)
      end
    end

    context 'when tried to make a castling move' do
      let(:fen) { 'r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1' }

      before do
        allow(meta_data).to receive(:special_moves_state).and_return({ castling: true })
      end

      it 'makes the move' do
        source = :e1
        destination = :c1
        rook_source = :a1
        rook_destination = :d1
        previous_rook_source = board[rook_source].piece
        previous_source_piece = board[source].piece
        board_operator.make_move(source, destination)
        current_source_piece = board[source].piece
        current_destination_piece = board[destination].piece
        current_rook_source = board[rook_source].piece
        current_rook_destination = board[rook_destination].piece
        expect(current_source_piece).to eq(nil)
        expect(current_destination_piece).to eq(previous_source_piece)
        expect(current_rook_source).to eq(nil)
        expect(current_rook_destination).to eq(previous_rook_source)
      end

      it 'empties castling right of current color' do
        source = :e1
        destination = :c1
        board_operator.make_move(source, destination)
        expect(meta_data.castling_rights).to eq('kq')
      end
    end
  end

  describe '#king_in_check?' do
    context 'when white king is in check' do
      let(:fen) { 'rnb1kbnr/pp1ppppp/2p5/8/1q6/3P4/PPP1PPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns true' do
        result = board_operator.king_in_check?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is in check after promotion' do
      let(:fen) { 'N6k/1PPQPP2/6PP/8/8/1p6/3ppppp/K1r5 w - - 0 1' }

      it 'returns true' do
        result = board_operator.king_in_check?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is not in check' do
      let(:fen) { 'rnb1kbnr/pp1ppppp/1qp5/8/8/3P4/PPP1PPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns false' do
        result = board_operator.king_in_check?('white')
        expect(result).to eq(false)
      end
    end

    context 'when white king is not in check after promotion' do
      let(:fen) { 'N6k/1PPQPP2/6PP/8/8/1p6/3ppppp/K1b5 w - - 0 1' }

      it 'returns false' do
        result = board_operator.king_in_check?('white')
        expect(result).to eq(false)
      end
    end

    context 'when black king is in check' do
      let(:fen) { 'rnb1kbnr/pp1pp1pp/1qp2p2/7B/8/3P1PP1/PPP1P2P/RNBQK1NR w KQkq - 0 1' }

      it 'returns true' do
        result = board_operator.king_in_check?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is in check after promotion' do
      let(:fen) { 'Q6k/1PPQPP2/6PP/1K6/8/8/1ppppppp/8 w - - 0 1' }

      it 'returns true' do
        result = board_operator.king_in_check?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is not in check' do
      let(:fen) { 'rnb1kbnr/pp1ppppp/1qp5/7B/8/3P1PP1/PPP1P2P/RNBQK1NR w KQkq - 0 1' }

      it 'returns false' do
        result = board_operator.king_in_check?('black')
        expect(result).to eq(false)
      end
    end

    context 'when black king is not in check after promotion' do
      let(:fen) { 'N6k/1PPQPP2/6PP/1K6/8/8/1ppppppp/8 w - - 0 1' }

      it 'returns false' do
        result = board_operator.king_in_check?('black')
        expect(result).to eq(false)
      end
    end
  end

  describe '#checkmate?' do
    context 'when white king is in checkmate' do
      let(:fen) { 'rnb1kbnr/pppp1ppp/4p3/8/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 0 1' }

      it 'returns true' do
        result = board_operator.checkmate?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is in checkmate after promotion' do
      let(:fen) { '8/8/8/8/8/8/r7/3K1q2 w - - 0 1' }

      it 'returns true' do
        result = board_operator.checkmate?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is not in checkmate' do
      let(:fen) { 'rnb1kbnr/pppp1ppp/4p3/8/7q/5P2/PPPPP1PP/RNBQKBNR w KQkq - 0 1' }

      it 'returns false' do
        result = board_operator.checkmate?('white')
        expect(result).to eq(false)
      end
    end

    context 'when black king is in checkmate' do
      let(:fen) { 'rnb3nr/pp3ppp/4p3/1k2Q1b1/5P1q/RP1N1B2/P1PPPBPP/4K1NR w K - 0 1' }

      it 'returns true' do
        result = board_operator.checkmate?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is in checkmate after promotion' do
      let(:fen) { '1QB5/k7/8/8/8/2B5/8/1R6 w - - 0 1' }

      it 'returns true' do
        result = board_operator.checkmate?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is not in checkmate' do
      let(:fen) { 'rnb3nr/pp3ppp/4pb2/1k2Q3/5P1q/RP1N1B2/P1PPPBPP/4K1NR w K - 0 1' }

      it 'returns false' do
        result = board_operator.checkmate?('black')
        expect(result).to eq(false)
      end
    end
  end

  describe '#stalemate?' do
    context 'when white king is in stalemate' do
      let(:fen) { '2P4K/p7/8/1k6/4brq1/8/8/8 w - - 0 1' }

      it 'returns true' do
        result = board_operator.stalemate?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is in stalemate after promotion' do
      let(:fen) { '7k/8/8/8/1q6/8/2qppppp/K7 w - - 0 1' }

      it 'returns true' do
        result = board_operator.stalemate?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white king is not in stalemate' do
      let(:fen) { '2P4K/p7/8/1k6/4brq1/8/8/2Q5 w - - 0 1' }

      it 'returns false' do
        result = board_operator.stalemate?('white')
        expect(result).to eq(false)
      end
    end

    context 'when black king is in stalemate' do
      let(:fen) { '2P4K/8/7R/k7/6R1/8/8/1Q6 w - - 0 1' }

      it 'returns true' do
        result = board_operator.stalemate?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is in stalemate after promotion' do
      let(:fen) { '1Q2B3/8/k7/8/8/2B5/8/1R6 w - - 0 1' }

      it 'returns true' do
        result = board_operator.stalemate?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black king is not in stalemate' do
      let(:fen) { '2P4K/1p6/7R/k7/6R1/8/8/1Q6 w - - 0 1' }

      it 'returns false' do
        result = board_operator.stalemate?('black')
        expect(result).to eq(false)
      end
    end
  end

  describe '#color_has_no_legal_moves?' do
    context 'when white has no legal moves' do
      let(:fen) { '2P4K/p7/8/1k6/4brq1/8/8/8 w - - 0 1' }

      it 'returns true' do
        result = board_operator.color_has_no_legal_moves?('white')
        expect(result).to eq(true)
      end
    end

    context 'when white has legal moves' do
      let(:fen) { '2P4K/1p6/7R/k7/6R1/8/8/1Q6 w - - 0 1' }

      it 'returns false' do
        result = board_operator.color_has_no_legal_moves?('white')
        expect(result).to eq(false)
      end
    end

    context 'when black has no legal moves' do
      let(:fen) { '2P4K/8/7R/k7/6R1/8/8/1Qp5 w - - 0 1' }

      it 'returns true' do
        result = board_operator.color_has_no_legal_moves?('black')
        expect(result).to eq(true)
      end
    end

    context 'when black has legal moves' do
      let(:fen) { '2P4K/8/7R/k7/6R1/8/1r6/1Qp5 w - - 0 1' }

      it 'returns false' do
        result = board_operator.color_has_no_legal_moves?('black')
        expect(result).to eq(false)
      end
    end
  end

  describe '#remove_allies' do
    context 'for white color' do
      let(:fen) { '1nb2b1k/2qpp1rp/rp2P3/1p1Q1Pp1/2P1n3/p1B1p2P/PP1N1PPR/R3KBN1 w Q - 0 1' }

      before { board_operator.instance_variable_set(:@moves, %i[c6 d6 e6 c5 d5 e5 c4 d4 e4]) }

      it 'removes allies' do
        board_operator.remove_allies('white')
        result = board_operator.instance_variable_get(:@moves)
        expected_result = %i[c6 d6 c5 e5 d4 e4]
        expect(result).to eq(expected_result)
      end
    end

    context 'for black color' do
      let(:fen) { '1nb2b1k/2qpp1rp/rp2P3/1p1Q1Pp1/2P1n3/p1B1p2P/PP1N1PPR/R3KBN1 w Q - 0 1' }

      before { board_operator.instance_variable_set(:@moves, %i[c8 d8 e8 c7 d7 e7 c6 d6 e6]) }

      it 'removes allies' do
        board_operator.remove_allies('black')
        result = board_operator.instance_variable_get(:@moves)
        expected_result = %i[d8 e8 c6 d6 e6]
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#remove_moves_that_leads_to_check' do
    context 'for white color' do
      let(:fen) { '1nb4k/2qpp1rp/rp2P3/1p1Q1Pp1/1bP1n3/p3p2P/PPBN1PPR/R3KBN1 w Q - 0 1' }

      before { board_operator.instance_variable_set(:@moves, %i[e4 f3 b1 b3]) }

      it 'removes moves that leads to check' do
        board_operator.remove_moves_that_leads_to_check(:d2, 'white')
        result = board_operator.instance_variable_get(:@moves)
        expected_result = []
        expect(result).to eq(expected_result)
      end

      context 'when white en_passant leads to check' do
        let(:fen) { 'rnbqk1nr/p1ppp2p/5p1b/P3QPp1/1pP1P3/RP2K3/3P2PP/1NB2BNR w kq g6 0 1' }

        before { board_operator.instance_variable_set(:@moves, %i[e6 g6]) }

        it 'removes that move' do
          board_operator.remove_moves_that_leads_to_check(:f5, 'white')
          result = board_operator.instance_variable_get(:@moves)
          expected_result = [:e6]
          expect(result).to eq(expected_result)
        end
      end
    end

    context 'for black color' do
      let(:fen) { '1nb2r1k/3pp3/rp2P2q/1p1Q1pp1/1bP1n2R/p3p2P/PPBN1PP1/R3KBN1 w Q - 0 1' }

      before { board_operator.instance_variable_set(:@moves, %i[h7 h5 h4 g6 f6 e6 g7]) }

      it 'removes moves that leads to check' do
        board_operator.remove_moves_that_leads_to_check(:h6, 'black')
        result = board_operator.instance_variable_get(:@moves)
        expected_result = %i[h7 h5 h4]
        expect(result).to eq(expected_result)
      end

      context 'when black en_passant leads to check' do
        let(:fen) { 'rnbq2nr/p1pp1k1p/5p1b/P3pPp1/1pP1P3/RB2K2Q/1P1P2PP/1NB3NR b - c3 0 1' }

        before { board_operator.instance_variable_set(:@moves, %i[a3 c3]) }

        it 'removes that move' do
          board_operator.remove_moves_that_leads_to_check(:b4, 'black')
          result = board_operator.instance_variable_get(:@moves)
          expected_result = [:a3]
          expect(result).to eq(expected_result)
        end
      end
    end
  end

  describe '#find_king_position' do
    context 'for white color' do
      let(:fen) { '1nb4k/2qpp1rp/rp2P3/1p1Q1Pp1/1bP1n3/p3p2P/PPBN1PPR/R3KBN1 w Q - 0 1' }

      it 'finds king position' do
        result = board_operator.find_king_position('white')
        expected_result = :e1
        expect(result).to eq(expected_result)
      end
    end

    context 'for black color' do
      let(:fen) { '1nb2r1k/3pp3/rp2P2q/1p1Q1pp1/1bP1n2R/p3p2P/PPBN1PP1/R3KBN1 w Q - 0 1' }

      it 'finds king position' do
        result = board_operator.find_king_position('black')
        expected_result = :h8
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#move_leads_to_check?' do
    context 'when the move leads to white king check' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb6/1P6/2PQPPPP/RNB1KBNR w KQkq - 0 1' }

      it 'returns true' do
        source = :d2
        destination = :d1
        color = 'white'
        board_operator.moves_from_source(source, color)
        result = board_operator.move_leads_to_check?(source, destination, color)
        expect(result).to eq(true)
      end
    end

    context 'when the move leads to black king check' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb5B/1P6/2PQPPPP/RN2KBNR w KQkq - 0 1' }

      it 'returns true' do
        source = :e8
        destination = :e7
        color = 'black'
        board_operator.moves_from_source(source, color)
        result = board_operator.move_leads_to_check?(source, destination, color)
        expect(result).to eq(true)
      end
    end

    context 'when the move doesn\'t lead to white king check' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb5B/1P6/2PQPPPP/RN2KBNR w KQkq - 0 1' }

      it 'returns false' do
        source = :h4
        destination = :d8
        color = 'white'
        board_operator.moves_from_source(source, color)
        result = board_operator.move_leads_to_check?(source, destination, color)
        expect(result).to eq(false)
      end
    end

    context 'when the move doesn\'t lead to black king check' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/Pb5B/1P6/2PQPPPP/RN2KBNR w KQkq - 0 1' }

      it 'returns false' do
        source = :f8
        destination = :c5
        color = 'black'
        board_operator.moves_from_source(source, color)
        result = board_operator.move_leads_to_check?(source, destination, color)
        expect(result).to eq(false)
      end
    end
  end

  describe '#revert_move' do
    context 'for a regular move' do
      let(:fen) { 'rn1qkbnr/p1pp1p1p/6p1/4p3/PP5B/1P6/3QPPPP/RN2KBNR w KQkq - 0 1' }

      before do
        pieces_changed = { c3: 'pawn', b4: 'bishop' }
        allow(meta_data).to receive(:pieces_changed).and_return(pieces_changed)
        allow(board[:c3]).to receive(:update_current_cell_of_piece)
        allow(board[:b4]).to receive(:update_current_cell_of_piece)
      end

      it 'reverts the move' do
        board_operator.revert_move
        result = [board[:c3].piece, board[:b4].piece]
        expected_result = %w[pawn bishop]
        expect(result).to eq(expected_result)
      end
    end

    context 'for an en_passant move' do
      let(:fen) { 'rn1qkbnr/p2p1p1p/2P3p1/4p3/P6B/1P6/3QPPPP/RN2KBNR w KQkq - 0 1' }

      before do
        pieces_changed = { b5: 'pawn', c6: nil, c5: 'pawn' }
        allow(meta_data).to receive(:pieces_changed).and_return(pieces_changed)
        allow(board[:b5]).to receive(:update_current_cell_of_piece)
        allow(board[:c5]).to receive(:update_current_cell_of_piece)
      end

      it 'reverts the move' do
        board_operator.revert_move
        result = [board[:b5].piece, board[:c6].piece, board[:c5].piece]
        expected_result = ['pawn', nil, 'pawn']
        expect(result).to eq(expected_result)
      end
    end

    context 'for a castling move' do
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/1NBQ4/PPPPPPPP/2KR1BNR w Kkq - 0 1' }

      before do
        pieces_changed = { e1: 'king', a1: 'rook', c1: nil, d1: nil }
        allow(meta_data).to receive(:pieces_changed).and_return(pieces_changed)
        allow(board[:e1]).to receive(:update_current_cell_of_piece)
        allow(board[:a1]).to receive(:update_current_cell_of_piece)
      end

      it 'reverts the move' do
        board_operator.revert_move
        result = [board[:e1].piece, board[:a1].piece, board[:c1].piece, board[:d1].piece]
        expected_result = ['king', 'rook', nil, nil]
        expect(result).to eq(expected_result)
      end
    end
  end
end
