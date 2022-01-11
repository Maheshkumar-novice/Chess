#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/board'

describe 'Check' do
  subject(:board) { Board.new(fen) }

  describe 'Board#eliminate_check_context_moves' do
    context 'when eliminating self check moves' do
      context 'when eliminating self check moves of white pawn c2' do
        let(:fen) { 'rnb1kbnr/pppp1ppp/8/4p3/7q/3PP3/PPP2PPP/RNBQKBNR w KQkq - 1 3' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:c2)
          after_elimination = board.eliminate_check_context_moves(:c2, all_moves, 'white')
          result = board.classify_moves(:c2, after_elimination)
          expected_result = { empty: [],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of black king d8' do
        let(:fen) { 'rnb1kbnr/pppp1ppp/8/3Np3/6q1/3PP3/PPP2PPP/R1BQKBNR b KQkq - 4 4' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:d8)
          after_elimination = board.eliminate_check_context_moves(:d8, all_moves, 'black')
          result = board.classify_moves(:d8, after_elimination)
          expected_result = { empty: [:e8],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of black bishop d7' do
        let(:fen) { 'rnb1k1nr/ppppbppp/4Q3/3N1q2/3Pp3/4P3/PPP2PPP/R1B1KBNR b KQkq - 5 8' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:d7)
          after_elimination = board.eliminate_check_context_moves(:d7, all_moves, 'black')
          result = board.classify_moves(:d7, after_elimination)
          expected_result = { empty: [],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of white knight c3' do
        let(:fen) { 'r1b1k1nr/ppppbppp/4Q3/3N4/3Pp1q1/4PN2/PPnBKPPP/3R1B1R w kq - 2 13' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:c3)
          after_elimination = board.eliminate_check_context_moves(:c3, all_moves, 'white')
          result = board.classify_moves(:c3, after_elimination)
          expected_result = { empty: [],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of white king d2' do
        let(:fen) { 'r1b3nr/pppkbppp/8/6N1/3PpNq1/4PP2/PPnBK2P/3R1B1R w - - 1 17' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:d2)
          after_elimination = board.eliminate_check_context_moves(:d2, all_moves, 'white')
          result = board.classify_moves(:d2, after_elimination)
          expected_result = { empty: [:c2],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of black king c8' do
        let(:fen) { 'r1b2knr/pp1P1Npp/2p2b2/8/4pPq1/3NP3/PPnB1K1P/3R1B1R b - - 0 23' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:c8)
          after_elimination = board.eliminate_check_context_moves(:c8, all_moves, 'black')
          result = board.classify_moves(:c8, after_elimination)
          expected_result = { empty: [:d7],
                              captures: [:c7] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of black king d7' do
        let(:fen) { 'r1b3nr/pp1Pk1pp/2p2b2/6N1/4pP2/3NP1K1/PPnB3P/3R1B1R b - - 2 25' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:d7)
          after_elimination = board.eliminate_check_context_moves(:d7, all_moves, 'black')
          result = board.classify_moves(:d7, after_elimination)
          result[:empty] = result[:empty].sort
          expected_result = { empty: %i[e6 e8 c8].sort,
                              captures: [:e7] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of black king a5' do
        let(:fen) { 'r1b3nr/pp1P3p/2p3p1/7k/4p1N1/4P2K/PPnB3P/3R1B1R b - - 3 31' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:a5)
          after_elimination = board.eliminate_check_context_moves(:a5, all_moves, 'black')
          result = board.classify_moves(:a5, after_elimination)
          expected_result = { empty: [:b5],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of black knight d3' do
        let(:fen) { 'r1b3nr/pp1P3p/2p2Np1/6k1/4p3/4n1K1/PP1B3P/3R1B1R b - - 1 33' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:d3)
          after_elimination = board.eliminate_check_context_moves(:d3, all_moves, 'black')
          result = board.classify_moves(:d3, after_elimination)
          expected_result = { empty: [],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating self check moves of white bishop e2' do
        let(:fen) { '3nkb2/1p2nr1p/1P3Pp1/4P3/rpP5/p5Pb/Pq1BK2P/RN2R1N1 w - - 0 30' }

        it 'eliminates self check moves ' do
          all_moves = board.create_moves(:e2)
          after_elimination = board.eliminate_check_context_moves(:e2, all_moves, 'white')
          result = board.classify_moves(:e2, after_elimination)
          expected_result = { empty: [],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end
    end

    context 'when eliminating moves that wont remove check' do
      context 'when eliminating moves that wont remove check of white king c2' do
        let(:fen) { 'r1b2knr/pp1P1Npp/2p2b2/8/4pP2/3NP1q1/PPnB1K1P/3R1B1R w - - 1 24' }

        it 'eliminates moves that wont remove check' do
          all_moves = board.create_moves(:c2)
          after_elimination = board.eliminate_check_context_moves(:c2, all_moves, 'white')
          result = board.classify_moves(:c2, after_elimination)
          expected_result = { empty: [:d2],
                              captures: [:b3] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating moves that wont remove check of black bishop c6' do
        let(:fen) { 'r1b3nr/pp1P3p/2p1kbp1/6N1/4pP2/3NP1K1/PPnB3P/3R1B1R b - - 3 27' }

        it 'eliminates moves that wont remove check' do
          all_moves = board.create_moves(:c6)
          after_elimination = board.eliminate_check_context_moves(:c6, all_moves, 'black')
          result = board.classify_moves(:c6, after_elimination)
          expected_result = { empty: [],
                              captures: [:b5] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating moves that wont remove check of black king d5' do
        let(:fen) { 'r2Q2nr/p6p/1p6/4k3/4p1p1/2B1K2B/PP3R1P/7R b - - 0 41' }

        it 'eliminates moves that wont remove check' do
          all_moves = board.create_moves(:d5)
          after_elimination = board.eliminate_check_context_moves(:d5, all_moves, 'black')
          result = board.classify_moves(:d5, after_elimination)
          expected_result = { empty: [:d6],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating moves that wont remove check of black rook h8' do
        let(:fen) { 'r3Q1nr/B7/7p/4k3/4p3/4K2p/PP3R1P/7R b - - 2 45' }

        it 'eliminates moves that wont remove check' do
          all_moves = board.create_moves(:h8)
          after_elimination = board.eliminate_check_context_moves(:h8, all_moves, 'black')
          result = board.classify_moves(:h8, after_elimination)
          expected_result = { empty: [],
                              captures: [:d8] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating moves that wont remove check of black pawn f7' do
        let(:fen) { 'r2nkb2/1pp1nr1p/1P1qbPp1/pB1pP3/4p3/2P3P1/P2Q3P/RNB1K1NR b KQq - 1 17' }

        it 'eliminates moves that wont remove check' do
          all_moves = board.create_moves(:f7)
          after_elimination = board.eliminate_check_context_moves(:f7, all_moves, 'black')
          result = board.classify_moves(:f7, after_elimination)
          expected_result = { empty: [:f6],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating moves that wont remove check of white king e1' do
        let(:fen) { 'r2nkb2/1p2nr1p/1P3Pp1/1p2P3/2P5/p5Pb/PqQBp2P/RN1KR1N1 w q - 0 28' }

        it 'eliminates moves that wont remove check' do
          all_moves = board.create_moves(:e1)
          after_elimination = board.eliminate_check_context_moves(:e1, all_moves, 'white')
          result = board.classify_moves(:e1, after_elimination)
          expected_result = { empty: [],
                              captures: [:d2] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating moves that wont remove check of black rook h8' do
        let(:fen) { 'r2nkb2/1p2nr1p/1P3Pp1/4P3/QpP5/p5Pb/Pq1BK2P/RN2R1N1 b q - 1 29' }

        it 'eliminates moves that wont remove check' do
          all_moves = board.create_moves(:h8)
          after_elimination = board.eliminate_check_context_moves(:h8, all_moves, 'black')
          result = board.classify_moves(:h8, after_elimination)
          expected_result = { empty: [],
                              captures: [:h4] }
          expect(result).to eq(expected_result)
        end
      end

      context 'when eliminating moves that wont remove check of white bishop e2' do
        let(:fen) { '3nkb2/1p2nr1p/1P3Pp1/4q3/rpP5/p5Pb/P2BK2P/RNR3N1 w - - 0 31' }

        it 'eliminates moves that wont remove check' do
          all_moves = board.create_moves(:e2)
          after_elimination = board.eliminate_check_context_moves(:e2, all_moves, 'white')
          result = board.classify_moves(:e2, after_elimination)
          expected_result = { empty: [:d3],
                              captures: [] }
          expect(result).to eq(expected_result)
        end
      end
    end
  end
end
