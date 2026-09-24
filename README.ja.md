# mahjong-render

[![Gem Version](https://badge.fury.io/rb/mahjong-render.svg?icon=si%3Arubygems)](https://rubygems.org/gems/mahjong-render)
[![CI](https://github.com/kjun1/mahjong-render/actions/workflows/ci.yml/badge.svg)](https://github.com/kjun1/mahjong-render/actions/workflows/ci.yml)

[English README](README.md)

`mahjong-render` は、麻雀牌の compact notation から自己完結した SVG を作る Ruby ライブラリです。Ruby 版 Asciidoctor 向けの block macro も使えます。描画時に Node.js、ブラウザ、フォント、ネットワーク接続は不要です。

## 表示例

`405m456p789s12344z` の描画結果です。`405m` の `0m` は赤五萬を表します。

![萬子・筒子・索子と風牌を並べた手牌。2枚目は赤五萬。](examples/hand.png)

このプレビューはライブラリが出力した SVG から生成しています。

## インストールと描画

MRI Ruby 3.3 以上が必要です。検証対象のバージョンは[互換性とサポート](#互換性とサポート)を参照してください。RubyGems からインストールします。

```sh
gem install mahjong-render
```

このリポジトリのローカルビルドをインストールする場合は、次のコマンドを使います。

```sh
gem build mahjong-render.gemspec
gem install --local ./mahjong-render-0.2.1.gem
```

インストール後、次のコマンドで `hand.svg` を作成できます。

```sh
ruby -rmahjong_render -e 'print MahjongRender.render("405m456p789s12344z")' > hand.svg
```

Ruby コードからは次のように呼び出します。

```ruby
require "mahjong_render"

svg = MahjongRender.render("405m456p789s12344z")
File.write("hand.svg", svg)
```

返り値は牌画像をデータ URI で埋め込んだ SVG 文字列です。牌数や和了形の妥当性は判定しません。

## AsciiDoc で使う

Asciidoctor は gem 本体の実行時依存ではないため、別途インストールします。以下は単独の AsciiDoc 文書から `hand.html` を作る例です。

```sh
gem install asciidoctor
printf '= Mahjong hand\n\nmahjong::405m456p789s12344z[]\n' > hand.adoc
asciidoctor -r mahjong_render/asciidoctor hand.adoc
```

間隔の違う牌列を含む [AsciiDoc の例](examples/basic.adoc) もあります。拡張は HTML5 の block macro に対応します。macro 属性、inline macro、PDF 出力には対応しません。

牌のまとまりを少し離して見せるには、完成したグループの間に `|` を入れます。たとえば `mahjong::123m|456p|789s[]` と書きます。`|` は牌幅の4分の1の空白を追加し、`|(0.25)` と同じ幅です。幅を変える場合は `mahjong::123m|(0.5)456p[]` のように書けます。

## 記法とエラー

| 記法 | 意味 |
| --- | --- |
| `1m`～`9m` | 萬子 |
| `1p`～`9p` | 筒子 |
| `1s`～`9s` | 索子 |
| `1z`～`4z` | 東・南・西・北 |
| `5z`～`7z` | 白・發・中 |
| `0m`、`0p`、`0s` | 各色の赤五 |

同じ色の数字は `123m` のようにまとめられます。`10m` は `1m 0m` の2牌です。空白は完成したグループの間に入れられますが、見た目の間隔は変わりません。通常の牌間は SVG の12単位のままで、`|` は75単位を追加します。`|(0)` は追加幅0です。数値指定には0以上の十進数を使い、区切りは完成したグループの間に置きます。

不正な記法は `MahjongRender::NotationError` になります。`token`、先頭から0起算の文字位置 `position`、理由 `reason` を参照できます。たとえば `8z` は無効です。

メソッドと例外の詳細は [公開 API リファレンス](docs/api.md) を参照してください。

## 互換性とサポート

v0.2.x の保証対象は MRI Ruby 3.3、3.4、4.0 です。任意の Asciidoctor 拡張は Ruby Asciidoctor 2.x の HTML5 backend で検証します。他の Ruby 実装、Asciidoctor のバージョン、backend は保証対象外です。Ruby 3.2 は上流のサポート終了に伴い、保証対象から外しました。

0.x 系では破壊的変更を minor release で告知します。修正とセキュリティ対応は最新の minor 系列のみを対象とし、v0.2.x は v0.1.x に代わる保守系列です。[サポート案内](SUPPORT.md)、[セキュリティポリシー](SECURITY.md)、[行動規範](CODE_OF_CONDUCT.md)も参照してください。

## 開発とライセンス

devcontainer、または保証対象の MRI Ruby・Bundler・`rsvg-convert` を用意して検証します。

```sh
bundle install
bundle exec rake lint test assets:check licenses:check example:build
gem build mahjong-render.gemspec
ruby script/check_package.rb mahjong-render-0.2.1.gem
```

設計の経緯は [既存ライブラリの調査](docs/research/existing-renderers.md) と [ADR](docs/adr/) に記録しています。
[公開手順](docs/release.md) には、タグから起動する Trusted Publishing の手順を記載しています。

Copyright 2026 kjun1。Ruby コードとテキスト文書には [Apache-2.0](LICENSE) を適用します。同梱の牌画像と [README のプレビュー](examples/hand.png) は CC0-1.0 です。牌画像は [FluffyStuff/riichi-mahjong-tiles](https://github.com/FluffyStuff/riichi-mahjong-tiles) から採用しました。詳細は [第三者素材の告知](THIRD_PARTY_NOTICES.md)、[素材マニフェスト](assets/manifest.json)、[CC0 のライセンス本文](LICENSES/CC0-1.0.txt) を参照してください。
