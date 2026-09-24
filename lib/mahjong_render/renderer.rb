# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

module MahjongRender
  module Renderer
    TILE_WIDTH = 300
    TILE_HEIGHT = 400
    GAP = 12
    ASSET_DIRECTORY = File.expand_path("../../assets/tiles", __dir__)
    XML_ESCAPE = { "&" => "&amp;", '"' => "&quot;", "<" => "&lt;", ">" => "&gt;" }.freeze
    SUIT_NAMES = { "m" => "characters", "p" => "circles", "s" => "bamboo" }.freeze
    ASSET_SUITS = { "m" => "Man", "p" => "Pin", "s" => "Sou" }.freeze
    HONORS = {
      "1" => ["Ton.svg", "east wind"],
      "2" => ["Nan.svg", "south wind"],
      "3" => ["Shaa.svg", "west wind"],
      "4" => ["Pei.svg", "north wind"],
      "5" => ["Haku.svg", "white dragon"],
      "6" => ["Hatsu.svg", "green dragon"],
      "7" => ["Chun.svg", "red dragon"]
    }.freeze

    module_function

    def render(tiles)
      width = (tiles.length * TILE_WIDTH) + ((tiles.length - 1) * GAP)
      %(<svg #{svg_attributes(tiles, width)}>#{image_elements(tiles).join}</svg>)
    end

    def svg_attributes(tiles, width)
      label = "Mahjong tiles: #{tiles.map { |tile| tile_label(tile) }.join(', ')}".gsub(/[&"<>]/, XML_ESCAPE)
      %(xmlns="http://www.w3.org/2000/svg" width="#{width}" height="#{TILE_HEIGHT}" ) +
        %(viewBox="0 0 #{width} #{TILE_HEIGHT}" role="img" aria-label="#{label}" style="max-width:100%;height:auto")
    end
    private_class_method :svg_attributes

    def image_elements(tiles)
      uris = {}
      front = encode_asset("Front.svg")
      tiles.each_with_index.map do |tile, index|
        x = index * (TILE_WIDTH + GAP)
        uri = uris[tile] ||= data_uri(tile)
        image_element(x, front) + image_element(x, uri)
      end
    end
    private_class_method :image_elements

    def image_element(left, uri)
      %(<image x="#{left}" y="0" width="#{TILE_WIDTH}" height="#{TILE_HEIGHT}" href="#{uri}" />)
    end
    private_class_method :image_element

    def tile_label(tile)
      rank = tile[0]
      suit = tile[1]
      return HONORS.fetch(rank).last if suit == "z"
      return "red 5 of #{SUIT_NAMES.fetch(suit)}" if rank == "0"

      "#{rank} of #{SUIT_NAMES.fetch(suit)}"
    end
    private_class_method :tile_label

    def data_uri(tile)
      rank = tile[0]
      suit = tile[1]
      filename = if suit == "z"
                   HONORS.fetch(rank).first
                 elsif rank == "0"
                   "#{ASSET_SUITS.fetch(suit)}5-Dora.svg"
                 else
                   "#{ASSET_SUITS.fetch(suit)}#{rank}.svg"
                 end
      encode_asset(filename)
    end
    private_class_method :data_uri

    def encode_asset(filename)
      bytes = File.binread(File.join(ASSET_DIRECTORY, filename))
      "data:image/svg+xml;base64,#{[bytes].pack('m0')}"
    end
    private_class_method :encode_asset
  end
end
