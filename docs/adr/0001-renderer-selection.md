# ADR 0001: Renderer selection

Status: accepted for v0.1.0.

The core must run with Ruby alone. The [ecosystem review](../research/existing-renderers.md) found capable JavaScript and TeX renderers, but using either at runtime would add another language or a TeX installation. The Ruby Jekyll plugin is coupled to Liquid and separate image files, and its regex parser does not enforce valid input.

Reuse [FluffyStuff's CC0 tile artwork](https://github.com/FluffyStuff/riichi-mahjong-tiles), pinned by commit and checksums. Implement only the missing strict compact-notation parser and a Ruby SVG compositor. Keep Asciidoctor in an optional adapter. Do not copy code from the rejected renderers.
