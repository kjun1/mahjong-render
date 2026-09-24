# ADR 0004: Asset strategy

Status: accepted for v0.1.0.

Bundle the 37 normal and red-five SVG faces plus the tile-front SVG from the pinned CC0 source. Layer the front below each face. Each rendered SVG embeds the needed asset bytes as `data:image/svg+xml;base64` image references. This keeps repeated SVGs deterministic and independent of external files, network requests, document-wide IDs, and installed fonts. The tradeoff is a larger output for hands containing repeated tiles; v0.1 prioritizes offline portability. CI verifies source hashes, XML structure, and absence of active or external SVG content.
