# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require "asciidoctor"
require "asciidoctor/extensions"
require_relative "../mahjong_render"

module MahjongRender
  class UnsupportedBackendError < StandardError; end
  class UnsupportedAttributeError < StandardError; end

  module Asciidoctor
    class BlockMacro < ::Asciidoctor::Extensions::BlockMacroProcessor
      use_dsl
      named :mahjong

      def process(parent, target, attrs)
        raise UnsupportedBackendError, "mahjong block macro supports HTML output only" unless parent.document.basebackend?("html")
        raise UnsupportedAttributeError, "mahjong block macro does not support attributes: #{attrs.keys.join(', ')}" unless attrs.empty?

        svg = MahjongRender.render(target)
        create_pass_block(parent, %(<div class="mahjong-render">#{svg}</div>), {}, subs: nil)
      end
    end
  end
end

Asciidoctor::Extensions.register do
  block_macro MahjongRender::Asciidoctor::BlockMacro
end
