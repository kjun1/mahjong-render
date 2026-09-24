# frozen_string_literal: true

# Copyright 2026 kjun1
# SPDX-License-Identifier: Apache-2.0

require "rubygems/package"
require_relative "../lib/mahjong_render/version"

root = File.expand_path("..", __dir__)
package = Gem::Package.new(ARGV.fetch(0))
spec = package.spec
files = package.contents

abort "unexpected gem name or version" unless spec.name == "mahjong-render" && spec.version.to_s == MahjongRender::VERSION
abort "incorrect gem licenses" unless spec.licenses.sort == %w[Apache-2.0 CC0-1.0].sort
abort "incorrect gem author" unless spec.authors == ["kjun1"]
abort "missing gem homepage" unless spec.homepage == "https://github.com/kjun1/mahjong-render"
abort "incorrect Ruby requirement" unless spec.required_ruby_version.to_s == ">= 3.3"
tag = "v#{MahjongRender::VERSION}"
abort "incorrect source URL" unless spec.metadata["source_code_uri"] == "https://github.com/kjun1/mahjong-render/tree/#{tag}"
abort "incorrect changelog URL" unless spec.metadata["changelog_uri"] == "https://github.com/kjun1/mahjong-render/blob/#{tag}/CHANGELOG.md"
abort "incorrect documentation URL" unless spec.metadata["documentation_uri"] == "https://github.com/kjun1/mahjong-render/blob/#{tag}/docs/api.md"
abort "gem file list differs from its contents" unless spec.files.sort == files.sort

required = %w[LICENSE LICENSES/CC0-1.0.txt THIRD_PARTY_NOTICES.md README.md README.ja.md
              CHANGELOG.md CONTRIBUTING.md SECURITY.md SUPPORT.md CODE_OF_CONDUCT.md docs/api.md
              assets/manifest.json assets/tiles/Front.svg examples/basic.adoc examples/hand.png
              docs/adr/0002-license.md docs/research/existing-renderers.md]
missing = required - files
abort "missing gem files: #{missing.join(', ')}" unless missing.empty?

%w[README.md README.ja.md].each do |readme|
  File.read(File.join(root, readme)).scan(/!?(?:\[[^\]]*\])\(([^)]+)\)/).flatten.each do |link|
    next if link.match?(%r{\Ahttps?://})

    target = link.split("#", 2).first
    next if target.empty?

    present = target.end_with?("/") ? files.any? { |file| file.start_with?(target) } : files.include?(target)
    abort "broken packaged link in #{readme}: #{link}" unless present
  end
end

puts "Checked #{files.length} packaged files and README links"
