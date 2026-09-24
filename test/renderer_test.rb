# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require_relative "test_helper"
require "open3"

class RendererTest < Minitest::Test
  def test_renders_a_self_contained_svg
    output = MahjongRender.render("10m5z")
    document = REXML::Document.new(output)
    assert_equal "svg", document.root.name
    assert_equal "924", document.root.attributes["width"]
    assert_equal "0 0 924 400", document.root.attributes["viewBox"]
    assert_equal "Mahjong tiles: 1 of characters, red 5 of characters, white dragon", document.root.attributes["aria-label"]

    images = document.get_elements("//image")
    assert_equal 6, images.length
    assert_equal(%w[0 0 312 312 624 624], images.map { |image| image.attributes["x"] })
    images.each do |image|
      uri = image.attributes["href"]
      assert uri.start_with?("data:image/svg+xml;base64,")
      embedded = uri.delete_prefix("data:image/svg+xml;base64,").unpack1("m0")
      assert_equal "svg", REXML::Document.new(embedded).root.name
    end
    refute_match(%r{https?://(?!www\.w3\.org/2000/svg)}, output)
  end

  def test_red_five_uses_distinct_artwork
    document = REXML::Document.new(MahjongRender.render("50p"))
    images = document.get_elements("//image")
    assert_equal images[0].attributes["href"], images[2].attributes["href"]
    refute_equal images[1].attributes["href"], images[3].attributes["href"]
  end

  def test_output_is_deterministic
    assert_equal MahjongRender.render("123m456p"), MahjongRender.render("123m456p")
  end

  def test_svg_can_be_rasterized
    stdout, stderr, status = Open3.capture3("rsvg-convert", "-f", "png", stdin_data: MahjongRender.render("405m123z"))
    assert status.success?, stderr
    assert_equal "\x89PNG\r\n\x1A\n".b, stdout.b.byteslice(0, 8)
  end
end
