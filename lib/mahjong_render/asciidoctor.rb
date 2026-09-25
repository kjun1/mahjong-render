# frozen_string_literal: true

# Copyright 2026 kjun1
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

        unsupported_attrs = attrs.keys - ["title"]
        unless unsupported_attrs.empty?
          message = "mahjong block macro does not support attributes: #{unsupported_attrs.join(', ')}"
          raise UnsupportedAttributeError, message
        end

        svg = MahjongRender.render(target)
        title_html = attrs.key?("title") ? %(<div class="title">#{attrs['title']}</div>\n) : ""
        create_pass_block(parent, %(<div class="mahjong-render">#{title_html}#{svg}</div>), attrs, subs: nil)
      end
    end
  end
end

Asciidoctor::Extensions.register do
  block_macro MahjongRender::Asciidoctor::BlockMacro
end
