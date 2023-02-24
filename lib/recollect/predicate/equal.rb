# frozen_string_literal: true

module Recollect
  module Equal
    def self.check!(item, iteratee, expected_value)
      expected_value == Utility::TryFetchOrBlank[item, iteratee]
    end
  end

  module NotEqual
    def self.check!(item, iteratee, value)
      !Equal.check!(item, iteratee, value)
    end
  end
end
