# Release process

1. Confirm `CHANGELOG.md` and `lib/mahjong_render/version.rb` use the intended SemVer version. Recheck that `mahjong-render` is available on RubyGems; a prior missing-name response does not reserve it.
2. In the devcontainer, run `bundle exec rake lint test assets:check licenses:check example:build`, `gem build mahjong-render.gemspec`, and `ruby script/check_package.rb mahjong-render-0.1.0.gem`. Confirm the build has no warnings.
3. Install the built gem locally and reproduce the Ruby and AsciiDoc commands in both READMEs without network access. Inspect the gem contents and confirm the Apache-2.0 license, CC0 legal text, artwork, notices, preview image, examples, and linked documentation are present.
4. For the first release, create the public `kjun1/mahjong-render` GitHub repository. Confirm the homepage and gem metadata URLs resolve, verify CI on the default branch, and enable GitHub private vulnerability reporting.
5. Review and date the 0.1.0 changelog entry. Configure Trusted Publishing as described below, then choose one of the release triggers.
6. After publication, confirm the RubyGems version and ownership, install the gem from RubyGems, and check that the pending publisher became a trusted publisher.

## Trusted Publishing setup

1. In the GitHub repository, create an environment named `release` under **Settings → Environments**. If deployment branch and tag restrictions are enabled, allow the `main` branch and `v*` tags.
2. Enable MFA for the RubyGems account. The gemspec sets `rubygems_mfa_required` to `true`.
3. Sign in to RubyGems and open [Pending trusted publishers](https://rubygems.org/profile/oidc/pending_trusted_publishers). Create a pending publisher with these exact values:

   | Field | Value |
   | --- | --- |
   | Gem name | `mahjong-render` |
   | Repository owner | `kjun1` |
   | Repository name | `mahjong-render` |
   | Workflow filename | `release.yml` |
   | Environment | `release` |
   | Workflow repository owner/name | Leave blank |

   No RubyGems API key or GitHub secret is needed. RubyGems converts the pending publisher after the first successful push.

## Choose a release trigger

- **Manual event:** Open GitHub **Actions → Publish gem → Run workflow**, select the `main` branch, and enter version `0.1.0`. The workflow publishes the version in `main` without creating a Git tag.
- **Tag push:** On `main`, push a tag matching the gem version, for example `git tag v0.1.0` followed by `git push origin v0.1.0`. The workflow requires the tagged commit to be on `main` before publishing.

Both routes validate the version, run the release checks, build the gem, and use the `release` environment. If a version from this repository is already on RubyGems, a later run checks its source metadata and skips the duplicate push. The RubyGems version cannot be overwritten; bump the gem version for any subsequent release.
