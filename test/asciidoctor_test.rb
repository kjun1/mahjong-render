# frozen_string_literal: true

# Copyright 2026 kjun1
# SPDX-License-Identifier: Apache-2.0

require_relative "test_helper"
require "asciidoctor"
require "mahjong_render/asciidoctor"

class AsciidoctorTest < Minitest::Test
  def test_example_builds_with_group_spacing
    html = Asciidoctor.convert_file("examples/basic.adoc", safe: :safe, to_file: false)
    assert_equal 3, html.scan("<svg ").length
    assert_includes html, "mahjong-render"
    assert_equal %w[4356 4356 3021], html.scan(/<svg [^>]*\bwidth="([^"]+)"/).flatten
    refute_includes html, "mahjong::"
  end

  def test_supports_standard_block_title
    html = Asciidoctor.convert(".Current hand\nmahjong::1m[]", safe: :safe)
    assert_includes html, %(<div class="title">Current hand</div>)
    assert_includes html, %(<div class="mahjong-render">)
  end

  def test_rejects_unsupported_attributes
    assert_raises(MahjongRender::UnsupportedAttributeError) do
      Asciidoctor.convert("mahjong::1m[onclick=alert(1)]", safe: :safe)
    end
  end

  def test_numeric_gaps_pass_through_macro
    html = Asciidoctor.convert("mahjong::1m|(0.25)2m|(0.5)3m[]", safe: :safe)
    assert_equal ["1149"], html.scan(/<svg [^>]*\bwidth="([^"]+)"/).flatten
  end

  def test_rejects_non_html_backend
    assert_raises(MahjongRender::UnsupportedBackendError) do
      Asciidoctor.convert("mahjong::1m[]", backend: "docbook", safe: :safe)
    end
  end
end
