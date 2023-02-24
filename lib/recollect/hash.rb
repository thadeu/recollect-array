# frozen_string_literal: true

module Recollect
  module Hash
    # ### Hash.get
    # `fetch value into hash, like Lodash.get`
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: ['1'] }
    # Recollect::Hash.get(hash, :b, :c)
    # ````
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: ['1'] }
    # Recollect::Hash.get(hash, 'd.0')
    # ````
    #
    # ````
    # hash = { a: 1, b: { c: 2 }, d: [{ e: 3 }] }
    # Recollect::Hash.get(hash, 'd.0.e')
    # ````
    def self.get(data, *keys)
      Utility::TryFetchOrBlank.call(data, *keys)
    end
  end
end
