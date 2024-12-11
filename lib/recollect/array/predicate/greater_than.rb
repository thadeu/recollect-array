# frozen_string_literal: true

module Recollect::Array
  module GreaterThan
    def self.check!(item, iteratee, right)
      left = Utility::TryFetchOrBlank[item, iteratee]
      return false unless left

      compare(left, right)
    end

    def self.compare(left, right)
      left > right
    end
  end

  module GreaterThanEqual
    def self.check!(item, iteratee, right)
      left = Utility::TryFetchOrBlank[item, iteratee]
      return false unless left

      compare(left, right)
    end

    def self.compare(left, right)
      left >= right
    end
  end
end
