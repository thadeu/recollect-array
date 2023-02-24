# frozen_string_literal: true

module Recollect
  module Equal
    def self.check!(item, iteratee, value)
      fetched_value = Utility::TryFetchOrBlank[item, iteratee]
      return false unless fetched_value

      fetched_value == value
    end
  end

  module NotEqual
    def self.check!(item, iteratee, value)
      !Equal.check!(item, iteratee, value)
    end
  end
end
