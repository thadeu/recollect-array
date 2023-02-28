# frozen_string_literal: true

module Recollect::Array
  module Endify
    def self.check!(item, iteratee, value)
      fetched_value = Utility::TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      regex = /#{value}$/
      fetched_value.to_s.match?(regex)
    end
  end

  module NotEndify
    def self.check!(item, iteratee, value)
      !Endify.check!(item, iteratee, value)
    end
  end
end
