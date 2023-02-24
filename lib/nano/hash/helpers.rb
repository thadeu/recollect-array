# frozen_string_literal: true

module Nano
  # ### TryFetchOrBlank
  # `fetch value into hash, like Lodash.get`
  #
  # ````
  # hash = { a: 1, b: { c: 2 }, d: ['1'] }
  # Nano::TryFetchOrBlank.call(hash, :b, :c)
  # ````
  #
  # ````
  # hash = { a: 1, b: { c: 2 }, d: ['1'] }
  # Nano::TryFetchOrBlank[hash, 'd.0']
  # ````
  #
  # ````
  # hash = { a: 1, b: { c: 2 }, d: [{ e: 3 }] }
  # Nano::TryFetchOrBlank.(hash, 'd.0.e')
  # ````
  TryFetchOrBlank = lambda do |data, *keys|
    keys.reduce(data) do |memo, key|
      symbolized_keys = key.to_s.split('.').map do |k|
        if k.is_a?(Numeric) || k.match?(/\d/)
          k.to_i
        else
          k.to_sym
        end
      end

      memo.dig(*symbolized_keys)
    end
  end

  module Hash
    # ### TryFetchOrBlank
    # `fetch value into hash, like Lodash.get`
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: ['1'] }
    # Nano::Hash.get(hash, :b, :c)
    # ````
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: ['1'] }
    # Nano::Hash.get(hash, 'd.0')
    # ````
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: [{ e: 3 }] }
    # Nano::Hash.get(hash, 'd.0.e')
    # ````
    def self.get(data, *keys)
      TryFetchOrBlank[data, *keys]
    end
  end
end
