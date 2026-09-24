# Existing ecosystem review

Reviewed for v0.1.0 on 2026-09-24. `yes/no/unclear` describes documented capability, not a promise of API compatibility. Maintenance is based on upstream activity visible at review time. Browser and Node columns concern direct use without a translation layer.

| Project / repository | Language | Code / asset license | Notation / parser | SVG / red five / meld | Browser / Node | Maintenance | Reusable / integration cost / decision |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [mahjong-font](https://github.com/rutopio/mahjong-font) | TypeScript | MIT / SIL OFL 1.1 font | tile strings; parser tied to application | yes / yes / unclear | yes / unclear | active in 2026 | Font is reusable in principle; hosted image API violates offline runtime, application is not a Ruby gem. Do not depend on it. |
| [mjimage](https://github.com/konoui/mjimage) | TypeScript | MIT / tile-image provenance not established in repository docs | compact notation; parser yes | yes / yes / yes | yes / yes | active in 2026 | npm package exists, but requires a JS runtime and separately hosted tile images by default. High integration cost for Ruby-only operation; do not depend on it. |
| [mahjong-tiles](https://github.com/DrCMWither/mahjong-tiles) | LaTeX3 | MIT / CC0 art stated upstream | extended MPSZF; parser internal | PDF asset composition, not direct SVG / yes / yes | no / no | active in 2026 | Requires TeX and PDF assets. Good notation reference; not a suitable runtime renderer. |
| [mahjong-tex](https://github.com/Schmytzi/mahjong-tex) | LaTeX3 | MIT / README credits CC BY art | MPSZ; parser internal | PDF asset composition, not direct SVG / yes / yes | no / no | maintenance unclear | Requires TeX and cannot provide a small Ruby-only SVG path. Do not depend on it. |
| [tilekit](https://github.com/csimi/tilekit) | JavaScript | ISC / Arphic Public License glyph data | compact notation; parser yes | yes / yes / no | yes / yes | 2026 release, short history | Small direct SVG library, but Ruby-only runtime excludes it; transitive glyph-data terms would need separate attribution. Do not depend on it. |
| [jekyll-mahjong](https://github.com/peter1357908/jekyll-mahjong) | Ruby | MIT / Uzaku font-derived art credited; asset terms need separate review | compact notation; regex in Liquid tag | individual SVG files in HTML / unclear / sideways tile | no / no | last repository activity in 2023 | Ruby-native, but coupled to Jekyll/Liquid, external CSS and separate image files. Regex skips invalid text. Do not adapt it for the public renderer. |
| [riichi-mahjong-tiles](https://github.com/FluffyStuff/riichi-mahjong-tiles) | SVG assets | CC0-1.0 | not applicable | yes / yes / not applicable | yes / yes | stable art; last pinned revision 2024 | Reuse 37 tile faces and the tile front. Low integration cost and clear redistribution terms. |

## AsciiDoc integration

[Ruby Asciidoctor's block macro extension](https://docs.asciidoctor.org/asciidoctor/latest/extensions/block-macro-processor/) already handles macro syntax and registration. The adapter uses that API and delegates only tile rendering to `MahjongRender.render`. No custom AsciiDoc parser is needed.

## Decision summary

The public runtime must work with Ruby alone. Reusing the CC0 tile vectors avoids recreating artwork. A small parser is needed because the available Ruby/Jekyll candidate silently skips invalid notation, while the JS and TeX parsers cannot be used without extra runtimes. The SVG composer only places those tile vectors into one offline image. See the [ADR](../adr/0001-renderer-selection.md).
