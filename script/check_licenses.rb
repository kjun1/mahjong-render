# frozen_string_literal: true

# Copyright 2026 kjun1
# SPDX-License-Identifier: Apache-2.0

require "bundler"
require "digest"

root = File.expand_path("..", __dir__)
apache_license = File.join(root, "LICENSE")
apache_license_sha256 = "cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30"
abort "Apache-2.0 legal text differs from the official copy" unless Digest::SHA256.file(apache_license).hexdigest == apache_license_sha256
abort "missing CC0 legal code" unless File.read(File.join(root, "LICENSES/CC0-1.0.txt")).include?("CC0 1.0 Universal")
notices = File.read(File.join(root, "THIRD_PARTY_NOTICES.md"))
abort "missing artwork attribution" unless notices.include?("FluffyStuff") && notices.include?("examples/hand.png")

project = Gem::Specification.load(File.join(root, "mahjong-render.gemspec"))
abort "incorrect project license metadata" unless project.licenses.sort == %w[Apache-2.0 CC0-1.0].sort
abort "incorrect public author" unless project.authors == ["kjun1"]

allowed = %w[MIT BSD-2-Clause BSD-3-Clause Apache-2.0 Ruby CC0-1.0 ISC]
specs = Bundler.load.specs.reject { |spec| spec.name == "mahjong-render" }
unapproved = specs.filter_map do |spec|
  licenses = spec.licenses
  "#{spec.name}: #{licenses.inspect}" unless licenses.any? { |license| allowed.include?(license) }
end
abort "Unapproved or missing dependency licenses:\n#{unapproved.join("\n")}" unless unapproved.empty?

puts "Checked #{specs.length} dependency licenses"
