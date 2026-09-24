# ADR 0005: Package strategy

Status: accepted for v0.1.0.

Distribute one Ruby gem named `mahjong-render`. `require "mahjong_render"` exposes the renderer without loading Asciidoctor. `require "mahjong_render/asciidoctor"` registers the HTML5 block macro when the separate `asciidoctor` gem is installed. This meets Ruby-only operation without splitting the small project into several packages. GitHub and RubyGems publication are separate follow-up actions after the local package, documentation, examples, CI, and license checks pass.
