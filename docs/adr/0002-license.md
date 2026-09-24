# ADR 0002: License

Status: accepted for v0.1.0.

Use Apache-2.0 (`SPDX-License-Identifier: Apache-2.0`) for project code and documentation, attributed to Maejima Kenya. The bundled tile SVGs and `examples/hand.png`, which is generated from those SVGs, remain independently CC0-1.0. Gem metadata lists both identifiers; `THIRD_PARTY_NOTICES.md` explains which files each covers because a license list alone cannot express component boundaries. Preserve the upstream declaration, full CC0 legal text, attribution, source revision, and file hashes. Keep optional and development dependency licenses separate from bundled content. CI fails when the Apache license copy changes or a locked dependency has no approved license metadata.
