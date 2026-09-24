# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require_relative "lib/mahjong_render/version"

Gem::Specification.new do |spec|
  spec.name = "mahjong-render"
  spec.version = MahjongRender::VERSION
  spec.summary = "Render riichi mahjong notation as self-contained SVG"
  spec.description = "A Ruby library for rendering compact mahjong notation to SVG, with an optional Asciidoctor block macro."
  spec.authors = ["Maejima Kenya"]
  spec.licenses = %w[Apache-2.0 CC0-1.0]
  spec.homepage = "https://github.com/kjun1/mahjong-render"
  spec.required_ruby_version = ">= 3.2"
  spec.files = (Dir.glob("{lib,assets,LICENSES,docs,examples}/**/*", File::FNM_DOTMATCH).select { |path| File.file?(path) } +
                %w[LICENSE README.md README.ja.md CHANGELOG.md CONTRIBUTING.md SECURITY.md THIRD_PARTY_NOTICES.md]).sort
  spec.require_paths = ["lib"]
  spec.metadata = {
    "source_code_uri" => "https://github.com/kjun1/mahjong-render",
    "changelog_uri" => "https://github.com/kjun1/mahjong-render/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/kjun1/mahjong-render/issues",
    "documentation_uri" => "https://github.com/kjun1/mahjong-render/blob/main/README.md",
    "rubygems_mfa_required" => "true"
  }
end
