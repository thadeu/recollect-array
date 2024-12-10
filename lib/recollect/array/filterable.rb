# frozen_string_literal: true

module Recollect
  module Array
    class FindByRootKey
      def self.call(data, key, filter)
        filter.each do |predicate, value|
          klass = Predicate.call(predicate)

          next unless !!klass

          data.filter! do |item|
            case value
            when Proc, Module
              klass.check!(item, key, value.call)
            else
              klass.check!(item, key, value)
            end
          end
        end
      end
    end

    class FindByNonRootKey
      def self.call(data, keys, filter)
        filter.each do |predicate, value|
          klass = Predicate.call(predicate)

          next unless !!klass

          data.filter! do |item|
            case value
            when Proc, Module
              klass.check!(item, keys, value.call)
            else
              klass.check!(item, keys, value)
            end
          end
        end
      end
    end

    class Filterable
      def self.call(data, filters)
        instance = new(data, filters)

        instance.call!
        instance.result
      end

      PREDICATES = %w[
        eq
        noteq
        not_eq
        cont
        notcont
        not_cont
        lt
        lteq
        gt
        gteq
        start
        notstart
        not_start
        end
        notend
        not_end
        in
        notin
        not_in
      ].freeze

      # Available filter
      attr_accessor :filters

      attr_reader :result

      def initialize(data, filters)
        @result = Array(data.dup)
        @filters = filters
      end
      private_class_method :new

      def call!
        @filters.each(&__apply_filter_callback)
      end

      def __apply_filter_callback
        lambda do |target|
          key, filter = target

          case filter
          when ::Hash
            keys_to_search = Utility::Keys.to_ary(key)
            is_root_key = keys_to_search.size == 1

            if is_root_key
              FindByRootKey.call(@result, keys_to_search, filter)
            else
              FindByNonRootKey.call(@result, keys_to_search, filter)
            end
          else
            parts = key.to_s.split('_')

            predicate = Array(parts[-2..]).filter do |pkey|
              next unless PREDICATES.include? pkey

              parts = parts - [pkey]
              pkey
            end&.last || :eq

            iteratee = parts.join('_')

            FindByRootKey.call(@result, iteratee, { predicate => filter })
          end
        end
      end
      private :__apply_filter_callback
    end

    Predicate = lambda do |named|
      {
        eq: Equal,
        noteq: NotEqual,
        not_eq: NotEqual,
        cont: Contains,
        notcont: NotContains,
        not_cont: NotContains,
        lt: LessThan,
        lteq: LessThanEqual,
        gt: GreaterThan,
        gteq: GreaterThanEqual,
        start: Startify,
        notstart: NotStartify,
        not_start: NotStartify,
        end: Endify,
        notend: NotEndify,
        not_end: NotEndify,
        in: Included,
        notin: NotIncluded,
        not_in: NotIncluded
      }[named.to_sym || :eq]
    end
    private_constant :Predicate
  end
end
