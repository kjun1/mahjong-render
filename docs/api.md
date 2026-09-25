# Public API

## Ruby rendering

```ruby
require "mahjong_render"
svg = MahjongRender.render("405m456p789s12344z")
```

`MahjongRender.render(notation)` accepts a String of [supported notation](../README.md#supported-notation) and returns a self-contained SVG String. The SVG embeds its tile artwork and can be saved directly or inserted into HTML. A non-String argument raises `TypeError`.

Invalid notation raises `MahjongRender::NotationError`. Its `token` reader identifies the invalid input, `position` is a zero-based character offset, and `reason` describes the problem. Tile count and legal mahjong hand shape are not validated.

## Asciidoctor block macro

Install Ruby Asciidoctor 2.x separately and load `mahjong_render/asciidoctor` to register the `mahjong` block macro:

```asciidoc
.Current hand
mahjong::405m456p789s12344z[]
```

Standard AsciiDoc block titles (`.Title` on the line before the macro) are supported and rendered above the tiles. The adapter supports the HTML5 backend. It raises `MahjongRender::UnsupportedBackendError` for other backends and `MahjongRender::UnsupportedAttributeError` for attributes written inside the macro's `[]`. Invalid notation raises `MahjongRender::NotationError`. Inline macros and PDF output are unsupported. Loading `mahjong_render` alone does not load Asciidoctor.
