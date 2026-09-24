# ADR 0003: Compact notation

Status: accepted for v0.1.0.

Use established MPSZ grouping: each digit before `m`, `p`, `s`, or `z` is one tile. `0` is a red five in suited groups; honors accept only `1` through `7`. `405m` means `4m 0m 5m`, and `10m` means `1m 0m`. The original request's `10m` invalid example conflicts with this rule and is corrected here. Reject malformed input without skipping characters, and report token, zero-based character position, and reason. Hand legality and tile-count checks are outside this rendering library.
