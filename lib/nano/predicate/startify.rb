# frozen_string_literal: true

module Nano
  module Startify
    def self.check!(item, iteratee, value)
      fetched_value = TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      regex = /^#{value}/
      fetched_value.to_s.match?(regex)
    end
  end

  module NotStartify
    def self.check!(item, iteratee, value)
      !Startify.check!(item, iteratee, value)
    end
  end
end
