# frozen_string_literal: true

module ActiveTruthy
  def self.call = true
end

module ActiveFalsey
  def self.call = false
end

module NumbersAvailable
  def self.call = %w[1 2]
end
