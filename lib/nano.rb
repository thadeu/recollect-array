# frozen_string_literal: true

module Nano
  require_relative 'nano/predicate/startify'
  require_relative 'nano/predicate/endify'
  require_relative 'nano/predicate/equal'
  require_relative 'nano/predicate/contains'
  require_relative 'nano/predicate/in'
  require_relative 'nano/predicate/less_than'
  require_relative 'nano/predicate/greater_than'

  require_relative 'nano/hash/helpers'
  require_relative 'nano/collection/search'
end
