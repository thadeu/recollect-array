# frozen_string_literal: true

require 'recollect/array/utility'
require 'recollect/array/hashie'
require 'recollect/array/predicate/startify'
require 'recollect/array/predicate/endify'
require 'recollect/array/predicate/equal'
require 'recollect/array/predicate/contains'
require 'recollect/array/predicate/in'
require 'recollect/array/predicate/less_than'
require 'recollect/array/predicate/greater_than'
require 'recollect/array/filterable'

module Recollect
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
