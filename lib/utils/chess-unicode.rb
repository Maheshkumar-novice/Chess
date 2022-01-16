#!/usr/bin/env ruby
# frozen_string_literal: true

# Chess Unicode
module ChessUnicode
  def character_to_unicode(character)
    {
      r: "\u265C", R: "\u2656",
      n: "\u265E", N: "\u2658",
      b: "\u265D", B: "\u2657",
      q: "\u265B", Q: "\u2655",
      k: "\u265A", K: "\u2654",
      p: "\u265F", P: "\u2659"
    }[character]
  end
end
