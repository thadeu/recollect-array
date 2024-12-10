# frozen_string_literal: true

module Recollect
  module Array
    class Filterable
      def self.call(data, filters)
        instance = new(data, filters)

        instance.call!
        instance.result
      end

      attr_reader :filters, :result

      def initialize(bigdata, filters)
        @result = Array(bigdata)
        @filters = filters
        @idx = ::Set.new
      end
      private_class_method :new

      def call!
        @result.each_with_index do |row, index|
          collected = @filters.collect do |key, condition|
            filter_by(row, key, condition)
          end.flatten.uniq

          case collected.all?
          in TrueClass then @idx.add(index)
          in FalseClass then @idx.delete(index)
          end
        end

        @result = @result.values_at(*@idx.to_a)
      end

      def filter_by(row, key, hash_or_value)
        case hash_or_value
        when ::Hash
          find_by_hash(key, hash_or_value, row)
        else
          find_by_other(key, hash_or_value, row)
        end
      end

      def find_by_hash(key, condition, row)
        condition.collect do |predicate, value|
          exists?(key, predicate, value, row)
        end
      end

      def find_by_other(key, value, row)
        parts = key.to_s.split('_')

        predicate = Array(parts[-2..]).filter do |pkey|
          next unless PREDICATES.include? pkey

          parts = parts - [pkey]

          pkey
        end&.last || :eq

        iteratee = parts.join('_')

        exists?(iteratee, predicate, value, row)
      end

      def exists?(iteratee, predicate, value, row)
        keys = Utility::Keys.to_ary(iteratee)

        klass = Predicate.call(predicate)
        return true unless !!klass

        valueable = value.respond_to?(:call) ? value.call : value
        klass.check!(row, keys, valueable)
      end
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

    AFFIRMATIVES = %w[
      eq
      in cont
      lt lteq
      gt gteq
      start end
    ].freeze

    NEGATIVES = %w[
      noteq not_eq
      notcont not_cont
      notstart not_start
      notend not_end
      notin not_in
    ].freeze

    PREDICATES = (AFFIRMATIVES + NEGATIVES).freeze
    private_constant :PREDICATES
  end
end
