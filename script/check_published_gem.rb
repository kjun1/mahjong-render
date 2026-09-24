# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require "digest"
require "json"
require_relative "../lib/mahjong_render/version"

metadata = JSON.parse(File.read(ARGV.fetch(0)))
gem_path = ARGV.fetch(1)
version = MahjongRender::VERSION
expected_source = "https://github.com/kjun1/mahjong-render/tree/v#{version}"
expected_sha = Digest::SHA256.file(gem_path).hexdigest

abort "published version differs" unless metadata.fetch("number") == version
abort "published Gem belongs to another source" unless metadata.dig("metadata", "source_code_uri") == expected_source
abort "published Gem differs from release build" unless metadata.fetch("sha") == expected_sha

puts "Published mahjong-render #{version} matches the release build (SHA-256 #{expected_sha})"
