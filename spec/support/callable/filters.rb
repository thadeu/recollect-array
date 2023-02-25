# frozen_string_literal: true

module ActiveTruthy
  def self.call
    true
  end
end

module ActiveFalsey
  def self.call
    false
  end
end

module NumbersAvailable
  def self.call
    %w[1 2]
  end
end
