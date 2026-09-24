# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require_relative "test_helper"
require "asciidoctor"
require "mahjong_render/asciidoctor"

class AsciidoctorTest < Minitest::Test
  def test_example_builds_with_both_hands
    html = Asciidoctor.convert_file("examples/basic.adoc", safe: :safe, to_file: false)
    assert_equal 2, html.scan("<svg ").length
    assert_includes html, "mahjong-render"
    refute_includes html, "mahjong::"
  end

  def test_rejects_unsupported_attributes
    assert_raises(MahjongRender::UnsupportedAttributeError) do
      Asciidoctor.convert("mahjong::1m[onclick=alert(1)]", safe: :safe)
    end
  end

  def test_rejects_non_html_backend
    assert_raises(MahjongRender::UnsupportedBackendError) do
      Asciidoctor.convert("mahjong::1m[]", backend: "docbook", safe: :safe)
    end
  end
end
