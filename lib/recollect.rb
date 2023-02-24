# frozen_string_literal: true

module Recollect
  require_relative 'recollect/predicate/startify'
  require_relative 'recollect/predicate/endify'
  require_relative 'recollect/predicate/equal'
  require_relative 'recollect/predicate/contains'
  require_relative 'recollect/predicate/in'
  require_relative 'recollect/predicate/less_than'
  require_relative 'recollect/predicate/greater_than'

  require_relative 'recollect/utility'
  require_relative 'recollect/hash'
  require_relative 'recollect/filterable'
  require_relative 'recollect/array'
end
