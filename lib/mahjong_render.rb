# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require_relative "mahjong_render/version"
require_relative "mahjong_render/parser"
require_relative "mahjong_render/renderer"

module MahjongRender
  def self.render(notation)
    Renderer.render(Parser.parse_layout(notation))
  end
end
