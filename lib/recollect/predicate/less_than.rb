# frozen_string_literal: true

module Recollect
  module LessThan
    def self.check!(item, iteratee, value)
      fetched_value = Utility::TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      fetched_value < value
    end
  end

  module LessThanEqual
    def self.check!(item, iteratee, value)
      fetched_value = Utility::TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      fetched_value <= value
    end
  end
end
