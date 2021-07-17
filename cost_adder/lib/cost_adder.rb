# frozen_string_literal: true

require "money"
require "monetize"

Money.default_currency = "USD"
Money.rounding_mode = 1
Money.locale_backend = :currency

DOLLAR_LOOKING_NUMBERS_ANYWHERE_REGEX = /(\d+\,?\d+?\.?\d{2}?)/
TRAILING_DOLLAR_NUMBERS_REGEX = /\$\S+/
TEXT_TO_PARSE_PATH = "costs_to_add.txt"
REGEX = ENV["AGGRESSIVE"] ? DOLLAR_LOOKING_NUMBERS_ANYWHERE_REGEX : TRAILING_DOLLAR_NUMBERS_REGEX

text_to_parse = File.read(TEXT_TO_PARSE_PATH)

total_cents = text_to_parse
  .scan(REGEX)
  .map{ |price| Monetize.parse(price).cents }
  .reduce(0, :+)

puts "Total: #{Money.new(total_cents, "USD").format}"
