# frozen_string_literal: true

module Recollect
  class Filterable
    def self.call(data, filters)
      instance = new(data, filters)
      instance.call!
      instance
    end

    # Original data
    private attr_accessor :data

    # Available filter
    private attr_accessor :filters

    attr_reader :result

    def initialize(data, filters)
      @result = Array(data)
      @filters = filters
    end
    private_class_method :new

    def call!
      @filters.each(&__apply_filter_callback)
    end

    def __apply_filter_callback
      lambda do |target|
        key, value = target
        parts = key.to_s.split('_')
        predicate = parts.pop
        iteratee = parts.join('_')
        klass = Predicate.call(predicate)

        next unless !!klass

        @result.filter! do |item|
          klass.check!(item, iteratee, value)
        end
      end
    end
    private :__apply_filter_callback
  end

  Predicate = lambda do |named|
    {
      eq: Equal, noteq: NotEqual,
      cont: Contains, notcont: NotContains,
      lt: LessThan, lteq: LessThanEqual,
      gt: GreaterThan, gteq: GreaterThanEqual,
      start: Startify, notstart: NotStartify,
      end: Endify, notend: NotEndify,
      in: Included, notin: NotIncluded
    }[named.to_sym]
  end
  private_constant :Predicate
end
