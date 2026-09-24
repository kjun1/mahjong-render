# frozen_string_literal: true

# Copyright 2026 Maejima Kenya
# SPDX-License-Identifier: Apache-2.0

module MahjongRender
  class NotationError < StandardError
    attr_reader :token, :position, :reason

    def initialize(token:, position:, reason:)
      @token = token
      @position = position
      @reason = reason
      super("#{reason} at character #{position}: #{token.inspect}")
    end
  end

  module Parser
    SUITS = %w[m p s z].freeze

    module_function

    def parse(notation)
      raise TypeError, "notation must be a String" unless notation.is_a?(String)

      tiles = []
      digits = +""
      start = nil

      notation.each_char.with_index do |char, position|
        if char.match?(/[0-9]/)
          start ||= position
          digits << char
        elsif SUITS.include?(char)
          error(char, position, "suit needs at least one digit") if digits.empty?
          digits.each_char.with_index do |digit, offset|
            error("#{digit}z", start + offset, "honor rank must be 1–7") if char == "z" && !digit.match?(/[1-7]/)
            tiles << "#{digit}#{char}"
          end
          digits.clear
          start = nil
        elsif char.match?(/\s/)
          error(digits, start, "missing suit before whitespace") unless digits.empty?
        else
          error(char, position, "unknown notation character")
        end
      end

      error(digits, start, "missing suit") unless digits.empty?
      error("", 0, "notation is empty") if tiles.empty?
      tiles.freeze
    end

    def error(token, position, reason)
      raise NotationError.new(token: token.dup, position: position, reason: reason)
    end
    private_class_method :error
  end
end
