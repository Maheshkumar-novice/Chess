#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/moves/check-finder'
require_relative '../../lib/board/utils/board-creator'
require_relative '../../lib/fen/fen-processor'

describe CheckFinder do
  subject(:check_finder) { described_class.new }
  let(:fen_processor) { FenProcessor.new }
  let(:board_creator) { BoardCreator.new }
  before { fen_processor.process(fen) }

  describe '#horizontal check?' do
    context 'when white king in check' do
      let(:fen) { '1R2kb1r/ppq2ppp/n1ppp3/3b2B1/4P1n1/2PP3P/PPQPNBP1/RN2K2r w Qk - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e1)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.horizontal_check?
        expect(result).to eq(true)
      end
    end

    context 'when white king not in check' do
      let(:fen) { 'rnb1k2r/p1pp1p1p/3qp1p1/2p3n1/1b2P3/2P1K1N1/PPBQPPPP/RN3B1R w kq - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e3)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.horizontal_check?
        expect(result).to eq(false)
      end
    end

    context 'when black king in check' do
      let(:fen) { '1R2kb1r/ppq2ppp/n1ppp3/3b2B1/4P1n1/2PPr2P/PP1P2P1/RN1QKBN1 w Qk - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e8)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.horizontal_check?
        expect(result).to eq(true)
      end
    end

    context 'when black king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/3qpkp1/2p3n1/1b2P3/2P1K1N1/PPBQPPPP/RN3B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :f6)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.horizontal_check?
        expect(result).to eq(false)
      end
    end
  end

  describe '#vertical check?' do
    context 'white king in check' do
      let(:fen) { '1R2kb1r/ppq2ppp/n1ppp1n1/3b2B1/1B1NP3/2PPK2P/PPQP2P1/RN2r3 w k - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e3)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.vertical_check?
        expect(result).to eq(true)
      end
    end

    context 'white king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/3qp1pk/2p3n1/1b2P3/2P2KN1/PPBQPPPP/RN3B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :f3)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.vertical_check?
        expect(result).to eq(false)
      end
    end

    context 'when black king in check' do
      let(:fen) { '5b1r/ppq1kppp/n1ppR1n1/3bp1B1/1B1NP3/2PPK2P/PPQP2P1/RN2r3 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e7)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.vertical_check?
        expect(result).to eq(true)
      end
    end

    context 'when black king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/3qp1pk/2p3n1/1b2P3/2P2KN1/PPBQPPPP/RN3B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :h6)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.vertical_check?
        expect(result).to eq(false)
      end
    end
  end

  describe '#diagonal check?' do
    context 'when white king in check' do
      let(:fen) { '5b1r/ppq1kppp/n1ppR1n1/2b1p1B1/1B2P1N1/1rPP3P/PPQP1KP1/RN6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :f2)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.diagonal_check?
        expect(result).to eq(true)
      end
    end

    context 'when white king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/3qp1pk/1bp3n1/4P3/K1P3N1/PPBQPPPP/RN3B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :a3)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.diagonal_check?
        expect(result).to eq(false)
      end
    end

    context 'when black king in check' do
      let(:fen) { '5b1r/ppq1kppp/n1pp2n1/2bRp1B1/1B2P1N1/1rPP3P/PPQP1KP1/RN6 w - - 0 11' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e7)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.diagonal_check?
        expect(result).to eq(true)
      end
    end

    context 'when black king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/k2qp1p1/1bp3n1/4P3/K1P3N1/PPBQPPPP/RN3B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :h6)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.diagonal_check?
        expect(result).to eq(false)
      end
    end
  end

  describe '#knight_check?' do
    context 'when white king in check' do
      let(:fen) { '5b1r/ppq1kppp/n1pp4/3Rp1BN/1Bb1P1n1/1rPP3P/PPQP1KP1/RN6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :f2)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.knight_check?
        expect(result).to eq(true)
      end
    end

    context 'when white king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/k1q1p1p1/1b1p2n1/3KP3/2P3N1/PPBQPPPP/RN3B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :d4)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.knight_check?
        expect(result).to eq(false)
      end
    end

    context 'when black king in check' do
      let(:fen) { '5b1r/ppq2ppp/n1ppk3/2R1p1NB/1Bb1P1n1/1rPP3P/PPQP1KP1/RN6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e6)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.knight_check?
        expect(result).to eq(true)
      end
    end

    context 'when black king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/2q1p1p1/1b1p1kn1/3K1P2/2P4N/PP1QPPPP/RN1B1B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :f5)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.knight_check?
        expect(result).to eq(false)
      end
    end
  end

  describe '#king_check?' do
    context 'when white king in check' do
      let(:fen) { '5b1r/ppq2ppp/n1pp4/PR2pnNB/PBb5/1rPPk2P/PPQ2KP1/RN6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :f2)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.king_check?
        expect(result).to eq(true)
      end
    end

    context 'when white king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/2q1p1p1/1b1p1kn1/5P1K/2P4N/PP1QPPPP/RN1B1B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :h4)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.king_check?
        expect(result).to eq(false)
      end
    end

    context 'when black king in check' do
      let(:fen) { '5b1r/ppq2ppp/n1pp4/PR2pnNB/PBb5/1rPPk2P/PPQ2KP1/RN6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e3)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.king_check?
        expect(result).to eq(true)
      end
    end

    context 'when black king not in check' do
      let(:fen) { 'rnb4r/p1pp1p1p/2q1p1p1/1b1p2n1/1P3P1K/k1P4N/P2QPPPP/R1NB1B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :a3)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.king_check?
        expect(result).to eq(false)
      end
    end
  end

  describe '#pawn_check?' do
    context 'when white king in check' do
      let(:fen) { '5b1r/ppq1kppp/n1p5/PR1P1n2/PBbp4/1rPPp1N1/PPQ2KPB/RN6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :f2)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.pawn_check?
        expect(result).to eq(true)
      end
    end

    context 'when white king not in check' do
      let(:fen) { 'rnb1K3/p1pp1prp/2q1p1p1/1b1p2n1/1P3P2/k1P4N/P2QPPPP/R1NB1B1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e8)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.pawn_check?
        expect(result).to eq(false)
      end
    end

    context 'when black king in check' do
      let(:fen) { '5b1r/ppq1kppp/n1pP4/PR2pn2/PBbp4/1rPP2N1/PPQ2KPB/RN6 w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e7)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns true' do
        result = check_finder.pawn_check?
        expect(result).to eq(true)
      end
    end

    context 'when black king not in check' do
      let(:fen) { 'rnb1K3/p1pp1prp/2q1p1p1/1b1p2n1/1P3P2/2P4N/PQ2PPPP/R1NBkB1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      before do
        check_finder.instance_variable_set(:@king_position, :e1)
        check_finder.instance_variable_set(:@board, board)
      end

      it 'returns false' do
        result = check_finder.pawn_check?
        expect(result).to eq(false)
      end
    end
  end

  describe '#king_in_check?' do
    context 'when white king when in check' do
      let(:fen) { 'rnb1K1r1/p1pp1p1p/2q1p1p1/1b1p2n1/1P3P2/2P4N/PQ2PPPP/R1NBkB1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns true' do
        king_position = :e8
        result = check_finder.king_in_check?(king_position, board)
        expect(result).to eq(true)
      end
    end

    context 'when white king when not in check' do
      let(:fen) { 'k4b1r/ppq2ppp/n1p5/PR1P1n2/PBbp4/1rPPp1N1/PPQ3PB/RN5K w Qk - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns false' do
        king_position = :h1
        result = check_finder.king_in_check?(king_position, board)
        expect(result).to eq(false)
      end
    end

    context 'when black king when in check' do
      let(:fen) { 'rnb1K1r1/p1pp1p1p/2q1p1p1/1b1p2n1/1P3P2/2P4N/P2QPPPP/R1NBkB1R w - - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns true' do
        king_position = :e1
        result = check_finder.king_in_check?(king_position, board)
        expect(result).to eq(true)
      end
    end

    context 'when black king when not in check' do
      let(:fen) { 'k4b1r/ppq2ppp/n1p5/PR1P1n2/PBbp4/1rPPp1N1/PPQ3PB/RN5K w Qk - 0 1' }
      let(:board) { board_creator.create_board(fen_processor.pieces) }

      it 'returns false' do
        king_position = :a8
        result = check_finder.king_in_check?(king_position, board)
        expect(result).to eq(false)
      end
    end
  end
end
