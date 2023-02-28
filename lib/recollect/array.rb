# frozen_string_literal: true


module Recollect
  require_relative 'array/utility'
  require_relative 'array/hashie'
  require_relative 'array/predicate/startify'
  require_relative 'array/predicate/endify'
  require_relative 'array/predicate/equal'
  require_relative 'array/predicate/contains'
  require_relative 'array/predicate/in'
  require_relative 'array/predicate/less_than'
  require_relative 'array/predicate/greater_than'
  require_relative 'array/filterable'

  module Array

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

    # ### Array.pluck
    # `fetch value into Array, like Lodash#pluck`
    #
    # ````
    # data = [{ a: 1, b: { c: 2 }, d: ['1'] }]
    # Recollect::Array.pluck(data, 'b.c')
    # ````
    def self.pluck(data, iteratee)
      return [] unless data.any?

      data.map { |item| Hashie.get(item, iteratee) }
    end
  end
end
