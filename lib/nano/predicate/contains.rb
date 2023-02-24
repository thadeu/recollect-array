# frozen_string_literal: true

module Nano
  module Contains
    def self.check!(item, iteratee, value)
      fetched_value = TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      fetched_value.to_s.match(/#{value}/)
    end
  end

  module NotContains
    def self.check!(item, iteratee, value)
      !Contains.check!(item, iteratee, value)
    end
  end
end
