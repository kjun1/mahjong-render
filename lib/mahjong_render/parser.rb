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
    MULTIPLIER = /\A[0-9]+(?:\.[0-9]+)?\z/
    DEFAULT_GAP_MULTIPLIER = Rational(1, 4)
    Layout = Struct.new(:tiles, :gaps, keyword_init: true)

    module_function

    def parse(notation)
      parse_layout(notation).tiles
    end

    def parse_layout(notation)
      raise TypeError, "notation must be a String" unless notation.is_a?(String)

      layout = Layout.new(tiles: [], gaps: [])
      digits = +""
      start = nil
      pending_gap = nil
      separator_position = nil
      chars = notation.chars
      position = 0

      while position < chars.length
        char = chars[position]
        if char.match?(/[0-9]/)
          start ||= position
          digits << char
        elsif SUITS.include?(char)
          error(char, position, "suit needs at least one digit") if digits.empty?
          append_tiles(layout, digits, char, start, pending_gap)
          pending_gap = nil
          digits.clear
          start = nil
        elsif char.match?(/\s/)
          error(digits, start, "missing suit before whitespace") unless digits.empty?
        elsif char == "|"
          validate_separator(layout.tiles, digits, start, pending_gap, position)
          separator_position = position
          pending_gap, position = parse_gap(chars, position)
        else
          error(char, position, "unknown notation character")
        end
        position += 1
      end

      error(digits, start, "missing suit") unless digits.empty?
      error("|", separator_position, "separator needs a following group") unless pending_gap.nil?
      error("", 0, "notation is empty") if layout.tiles.empty?
      freeze_layout(layout)
    end

    def append_tiles(layout, digits, suit, start, gap)
      digits.each_char.with_index do |digit, offset|
        error("#{digit}z", start + offset, "honor rank must be 1–7") if suit == "z" && !digit.match?(/[1-7]/)
        layout.gaps << (gap || 0) unless layout.tiles.empty?
        layout.tiles << "#{digit}#{suit}"
        gap = nil
      end
    end
    private_class_method :append_tiles

    def freeze_layout(layout)
      layout.tiles.freeze
      layout.gaps.freeze
      layout.freeze
    end
    private_class_method :freeze_layout

    def validate_separator(tiles, digits, start, pending_gap, position)
      error(digits, start, "missing suit before separator") unless digits.empty?
      error("|", position, "separator needs a preceding group") if tiles.empty?
      error("|", position, "consecutive separators") unless pending_gap.nil?
    end
    private_class_method :validate_separator

    def parse_gap(chars, position)
      return [DEFAULT_GAP_MULTIPLIER, position] unless chars[position + 1] == "("

      closing = position + 2
      closing += 1 while closing < chars.length && chars[closing] != ")"
      error("|(", position, "missing closing parenthesis for gap multiplier") if closing == chars.length

      token = chars[(position + 2)...closing].join
      error("|(#{token})", position, "invalid gap multiplier") unless MULTIPLIER.match?(token)

      [Rational(token), closing]
    end
    private_class_method :parse_gap

    def error(token, position, reason)
      raise NotationError.new(token: token.dup, position: position, reason: reason)
    end
    private_class_method :error
  end
end
