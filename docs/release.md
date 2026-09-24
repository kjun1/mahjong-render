# Release process

Releases are triggered only by a `vX.Y.Z` tag on a commit in `main`. The tag version must match `lib/mahjong_render/version.rb`. Do not publish a Gem manually: the tag workflow builds the Gem, checks reproducibility, publishes through RubyGems Trusted Publishing, attests the exact Gem, and creates the matching GitHub Release with that Gem attached.

## Prepare

1. Update the version in `lib/mahjong_render/version.rb` and `Gemfile.lock`, the support line in `SECURITY.md`, and a dated entry in `CHANGELOG.md`. Update user-facing version examples in both READMEs.
2. Run `bundle exec rake lint test assets:check licenses:check example:build`. Build the Gem and run `ruby script/check_package.rb` on it. Confirm the version-specific metadata URLs and packaged documentation.
3. Merge the release commit to `main` and confirm all CI jobs pass. Create an annotated tag on that commit, for example `git tag -a v0.2.0 -m 'Release v0.2.0'`, then push the tag with `git push origin v0.2.0`.

The `release` GitHub environment must allow `v*` tags. Configure the RubyGems trusted publisher for repository `kjun1/mahjong-render`, workflow `release.yml`, and environment `release`. Keep MFA enabled for the RubyGems account. The workflow does not use a RubyGems API key or GitHub secret.

## Verify

1. Confirm the `Publish gem` workflow succeeded for the tag, including the MRI Ruby 3.3, 3.4, and 4.0 checks.
2. Confirm the version exists on RubyGems and the matching GitHub Release has the `.gem` asset. Download the asset and the RubyGems Gem, and compare their SHA-256 hashes.
3. Verify the downloaded Gem's attestation with `gh attestation verify mahjong-render-X.Y.Z.gem -R kjun1/mahjong-render`. Install the published Gem and run the Ruby and AsciiDoc examples from both READMEs.

If the workflow fails after RubyGems publication, rerun the workflow for the same tag. It will rebuild the Gem with `SOURCE_DATE_EPOCH` set to the tagged commit time, compare its SHA-256 with RubyGems, and complete the attestation and GitHub Release. A mismatch stops the workflow; published Gem versions cannot be overwritten. RubyGems 0.1.0 predates this process and retains its original metadata.
