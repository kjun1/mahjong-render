ARG RUBY_VERSION=3.4
FROM ruby:${RUBY_VERSION}-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends git librsvg2-bin \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 1000 --shell /bin/bash vscode \
    && install -d -o vscode -g vscode /home/vscode/.bundle

WORKDIR /workspaces/mahjong-render

USER vscode
ENV BUNDLE_PATH=/home/vscode/.bundle
