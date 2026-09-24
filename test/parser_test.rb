# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require_relative "test_helper"

class ParserTest < Minitest::Test
  def test_compact_notation_and_red_five
    assert_equal %w[1m 2m 3m 4p 0p 5p 7s 8s 9s 1z 2z 3z 4z 4z],
                 MahjongRender::Parser.parse("123m405p789s12344z")
  end

  def test_ten_m_is_two_tiles
    assert_equal %w[1m 0m], MahjongRender::Parser.parse("10m")
  end

  def test_whitespace_between_runs
    assert_equal %w[1m 2p 3z], MahjongRender::Parser.parse(" 1m\n2p\t3z ")
  end

  def test_invalid_honor_reports_first_bad_digit
    error = assert_raises(MahjongRender::NotationError) { MahjongRender.render("123m48z") }
    assert_equal "8z", error.token
    assert_equal 5, error.position
    assert_match(/honor rank/, error.reason)
  end

  def test_invalid_characters_do_not_get_skipped
    { "123x" => 3, "1m!2p" => 2, "1m<svg" => 2 }.each do |input, position|
      error = assert_raises(MahjongRender::NotationError) { MahjongRender.render(input) }
      assert_equal position, error.position
    end
  end

  def test_missing_suit_and_empty_notation
    assert_raises(MahjongRender::NotationError) { MahjongRender.render("123") }
    assert_raises(MahjongRender::NotationError) { MahjongRender.render(" ") }
    assert_raises(MahjongRender::NotationError) { MahjongRender.render("1 m") }
  end

  def test_non_string_input
    assert_raises(TypeError) { MahjongRender.render(nil) }
  end
end
