# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

require "rake/testtask"
require "fileutils"

Rake::TestTask.new(:test) do |task|
  task.libs << "lib" << "test"
  task.pattern = "test/**/*_test.rb"
end

task :lint do
  sh "bundle exec rubocop"
end

namespace :assets do
  task :check do
    sh "bundle exec ruby script/check_assets.rb"
  end
end

namespace :licenses do
  task :check do
    sh "bundle exec ruby script/check_licenses.rb"
  end
end

namespace :example do
  task :build do
    require "asciidoctor"
    require_relative "lib/mahjong_render/asciidoctor"
    FileUtils.mkdir_p("tmp")
    Asciidoctor.convert_file("examples/basic.adoc", to_file: "tmp/basic.html", safe: :safe)
    abort "example did not contain SVG" unless File.read("tmp/basic.html").include?("<svg ")
  end
end

task default: %i[lint test]
