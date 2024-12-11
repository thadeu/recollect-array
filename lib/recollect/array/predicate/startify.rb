# frozen_string_literal: true

module Recollect::Array
  module Startify
    def self.check!(item, iteratee, right)
      left = Utility::TryFetchOrBlank[item, iteratee]
      return false unless left

      regex = /^#{right}/
      left.to_s.match?(regex)
    end

    def self.compare(left, right)
      regex = /^#{right}/
      left.to_s.match?(regex)
    end
  end

  module NotStartify
    def self.check!(item, iteratee, right)
      !Startify.check!(item, iteratee, right)
    end

    def self.compare(left, right)
      !Startify.compare(left, right)
    end
  end
end
