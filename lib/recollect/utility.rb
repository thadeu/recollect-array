# frozen_string_literal: true

module Recollect
  module Utility
    module Keys
      extend self

      DELIMITER_REGEX = /\[|\]|\./

      def to_ary(key)
        return [] if key.empty?

        key.to_s.split(DELIMITER_REGEX).reject(&:empty?)
      end
      alias [] to_ary

      def to_dig(key)
        enforce_level = ->(level) do
          if level.is_a?(Integer) || level.match?(/^\d$/)
            level.to_i
          else
            level.to_sym
          end
        end

        Keys[key].map(&enforce_level)
      end
    end

    # ### Utility::TryFetchOrBlank
    # `fetch value into hash, like Lodash.get`
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: ['1'] }
    # Utility::TryFetchOrBlank.call(hash, :b, :c)
    # ````
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: ['1'] }
    # Utility::TryFetchOrBlank[hash, 'd.0']
    # ````
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: [{ e: 3 }] }
    # Utility::TryFetchOrBlank.(hash, 'd.0.e')

    # hash = { a: 1, b: { c: 2 }, d: [{ e: 3 }] }
    # Utility::TryFetchOrBlank.(hash, 'd[0]e')

    # hash = { a: 1, b: { c: 2 }, d: [{ e: 3 }] }
    # Utility::TryFetchOrBlank.(hash, 'd.[0].e')
    # ````
    TryFetchOrBlank = ->(data, *keys) do
      reducer = ->(memo, key) do
        memo.dig(*Keys.to_dig(key))
      rescue StandardError
        nil
      end

      keys.reduce(data, &reducer)
    end
  end
end
