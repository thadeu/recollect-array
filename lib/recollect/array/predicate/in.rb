# frozen_string_literal: true

module Recollect::Array
  module Included
    def self.check!(item, iteratee, right)
      left = Array(Utility::TryFetchOrBlank[item, iteratee]).compact
      return false unless Array(left).count > 0

      compare(left, right)
    end

    def self.compare(arr, expected_array)
      Array(arr).any? do |item|
        Array(expected_array).include?(item)
      end
    end
  end

  module NotIncluded
    def self.check!(item, iteratee, value)
      !Included.check!(item, iteratee, value)
    end

    def self.compare(arr, expected_array)
      !Included.compare(arr, expected_array)
    end
  end
end
