# frozen_string_literal: true

module Recollect::Array
  module Contains
    def self.check!(item, iteratee, value)
      fetched_value = Utility::TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      Array(value).any? { |v| fetched_value.to_s.match(/#{v}/) }
    end
  end

  module NotContains
    def self.check!(item, iteratee, value)
      !Contains.check!(item, iteratee, value)
    end
  end
end
