# frozen_string_literal: true

module Recollect
  class Filterable
    def self.call(data, filters)
      instance = new(data, filters)
      instance.call!
      instance
    end

    # Available filter
    attr_accessor :filters

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

        case value
        when ::Hash
          value.each do |predicate, item_value|
            klass = Predicate.call(predicate)

            @result.filter! do |item|
              case item_value
              when Proc, Module
                klass.check!(item, key, item_value.call)
              else
                klass.check!(item, key, item_value)
              end
            end
          end
        else
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
    end
    private :__apply_filter_callback
  end

  Predicate = lambda do |named|
    {
      eq: Equal, noteq: NotEqual, not_eq: NotEqual,
      cont: Contains, notcont: NotContains, not_cont: NotContains,
      lt: LessThan, lteq: LessThanEqual,
      gt: GreaterThan, gteq: GreaterThanEqual,
      start: Startify, notstart: NotStartify, not_start: NotStartify,
      end: Endify, notend: NotEndify, not_end: NotEndify,
      in: Included, notin: NotIncluded, not_in: NotIncluded
    }[named.to_sym]
  end
  private_constant :Predicate
end
