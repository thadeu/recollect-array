# frozen_string_literal: true

module Recollect::Array
  module Included
    def self.check!(item, iteratee, value)
      fetched_value = Array(Utility::TryFetchOrBlank[item, iteratee]).compact
      return false unless Array(fetched_value).count > 0

      fetched_value.any? do |expected_value|
        Array(value).include?(expected_value)
      end
    end
  end

  module NotIncluded
    def self.check!(item, iteratee, value)
      !Included.check!(item, iteratee, value)
    end
  end
end
