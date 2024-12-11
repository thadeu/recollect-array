# frozen_string_literal: true

require 'set'

module Recollect
  module Array
    require_relative 'array/utility'
    require_relative 'array/predicate/startify'
    require_relative 'array/predicate/endify'
    require_relative 'array/predicate/equal'
    require_relative 'array/predicate/contains'
    require_relative 'array/predicate/in'
    require_relative 'array/predicate/less_than'
    require_relative 'array/predicate/greater_than'
    require_relative 'array/filterable'


    # ### Array.filter
    # `filter value into Array using conditions
    #
    # ````
    # data = [{ a: 1, b: { c: 2 }, d: ['1'] }]
    # filters = { a_eq: 1, 'b.c_eq': 2, d_in: ['1'] }
    # Recollect::Array.filter(data, filters)
    # ````
    def self.filter(data, filters = {})
      Filterable.call(data, filters)
    end
  end
end
