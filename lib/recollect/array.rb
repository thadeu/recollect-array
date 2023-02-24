# frozen_string_literal: true

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
    def filter(data, filters = {})
      Filterable.call(data, filters)
    end
    module_function :filter

    # ### Array.pluck
    # `fetch value into Array, like Lodash#pluck`
    #
    # ````
    # data = [{ a: 1, b: { c: 2 }, d: ['1'] }]
    # Recollect::Array.pluck(data, 'b.c')
    # ````
    def pluck(data, iteratee)
      return [] unless data.any?

      data.map { |item| Hash.get(item, iteratee) }
    end
    module_function :pluck
  end
end
