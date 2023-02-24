# frozen_string_literal: true

module Recollect
  module GreaterThan
    def self.check!(item, iteratee, value)
      fetched_value = Utility::TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      fetched_value > value
    end
  end

  module GreaterThanEqual
    def self.check!(item, iteratee, value)
      fetched_value = Utility::TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      fetched_value >= value
    end
  end
end
