# Contributing

Bug reports and pull requests are welcome. Describe the notation or AsciiDoc input, the expected result, and the actual result. Include a minimal sample when possible.

Run `bundle exec rake lint test assets:check licenses:check example:build` before submitting a change. Add focused tests for changes to parsing, SVG output, or the Asciidoctor adapter. Document changes to public behavior in the README and CHANGELOG.

Do not add third-party code or artwork without recording its origin, license, redistribution conditions, and any required notices. New artwork must be audited for active SVG content and external references. Keep the core renderer independent of Asciidoctor and of runtime network services.
