# frozen_string_literal: true

module Recollect::Array
  module Utility
    module Keys
      extend self

      DELIMITER_REGEX = /\[|\]|\./

      def to_ary(key)
        return [] if key.empty?

        if key.is_a?(::Array)
          return key.flat_map { |k| to_ary(k) }
        end

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
    TryFetchOrBlank = ->(data, *arr_keys) do
      reducer = ->(memo, key) do
        symbol_keys = *Keys.to_dig(key)

        deep_value = symbol_keys.reduce(memo) do |acc, attr|
          acc = acc.compact

          case acc
          in [::Integer, _] | [::String, _] | Integer
            acc[attr]
          in ::Array
            case acc
            in [::Hash, _]
              case attr
              in ::Integer
                acc&.dig(attr)
              else
                acc&.flat_map{|x| x&.dig(attr) }
              end
            else
              case attr
              in ::Integer | ::String
                acc&.dig(attr)
              else
                acc&.flat_map{|x| x.respond_to?(:dig) ? x&.dig(attr) : x }
              end
            end
          in ::Hash
            acc&.dig(attr)
          else
            acc
          end
        end

        deep_value
      rescue StandardError => e
        nil
      end

      arr_keys.reduce(data, &reducer)
    end
  end
end
