# frozen_string_literal: true

module Nano
  module Collection
    class Search
      def self.apply(data, filters)
        instance = new(data, filters)
        instance.apply!
        instance
      end

      # Original data
      attr_accessor :data

      private_instance_methods :data

      # Available filter
      attr_accessor :filters

      private_instance_methods :filters

      attr_reader :result

      def initialize(data, filters)
        @data = Array(data)
        @result = Array(data)
        @filters = filters
      end
      private_class_method :new

      def apply!
        @filters.each(&__apply_filter_callback)
      end

      private def __apply_filter_callback
        lambda do |target|
          key, value = target
          parts = key.to_s.split('_')
          predicate = parts.pop
          iteratee = parts.join('_')
          klass = __create_predicate(predicate)

          next unless !!klass

          @result.filter! do |item|
            klass.check!(item, iteratee, value)
          end
        end
      end

      private def __create_predicate(predicate = 'eq')
        {
          eq: Equal, noteq: NotEqual,
          cont: Contains, notcont: NotContains,
          lt: LessThan, lteq: LessThanEqual,
          gt: GreaterThan, gteq: GreaterThanEqual,
          start: Startify, notstart: NotStartify,
          end: Endify, notend: NotEndify,
          in: Included, notin: NotIncluded
        }[predicate.to_sym]
      end
    end
  end
end
