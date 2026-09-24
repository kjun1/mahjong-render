# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require "digest"
require "json"
require "rexml/document"

root = File.expand_path("..", __dir__)
manifest = JSON.parse(File.read(File.join(root, "assets/manifest.json")))
files = manifest.fetch("files")
expected = %w[Man Pin Sou].flat_map { |suit| (1..9).map { |rank| "#{suit}#{rank}.svg" } + ["#{suit}5-Dora.svg"] } +
           %w[Ton Nan Shaa Pei Haku Hatsu Chun Front].map { |name| "#{name}.svg" }
abort "asset list differs from 37 faces and tile front" unless files.keys.sort == expected.sort
abort "unexpected asset license" unless manifest.fetch("license") == "CC0-1.0"
abort "asset commit is not pinned" unless manifest.fetch("commit").match?(/\A[0-9a-f]{40}\z/)
allowed_elements = %w[svg defs g path circle ellipse rect linearGradient stop clipPath mask filter feGaussianBlur pattern use marker
                      namedview grid guide path-effect].freeze

files.each do |filename, digest|
  path = File.join(root, "assets/tiles", filename)
  data = File.binread(path)
  abort "checksum mismatch: #{filename}" unless Digest::SHA256.hexdigest(data) == digest
  abort "XML entities are not allowed: #{filename}" if data.match?(/<!DOCTYPE|<!ENTITY/i)

  document = REXML::Document.new(data)
  abort "unexpected root element: #{filename}" unless document.root.name == "svg"
  abort "unexpected tile viewBox: #{filename}" unless document.root.attributes["viewBox"] == "0 0 300 400"

  document.elements.each("//*") do |element|
    next if element.xpath.include?("metadata")

    abort "unexpected element in #{filename}: #{element.name}" unless allowed_elements.include?(element.name)
    element.attributes.each_attribute do |attribute|
      next if attribute.expanded_name.start_with?("xmlns")

      abort "event handler in #{filename}" if attribute.name.start_with?("on")
      abort "external reference in #{filename}" if (attribute.name == "href") && !attribute.value.start_with?("#")
      abort "external URL in #{filename}" if attribute.value.match?(%r{(?:javascript:|file:|https?://|url\(\s*['"]?(?!#))}i)
    end
  end
end

actual = Dir.glob(File.join(root, "assets/tiles/*.svg")).map { |path| File.basename(path) }
abort "untracked tile assets exist" unless actual.sort == expected.sort
puts "Checked #{files.length} pinned CC0 tile assets"
