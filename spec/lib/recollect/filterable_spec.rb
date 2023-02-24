# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Recollect::Filterable do
  let(:data) do
    [
      {
        id: 1,
        name: 'Test #1',
        email: 'test1@email1.com',
        schedule: { all_day: true, opened: true },
        numbers: %w[1 2],
        active: true,
        count: 9
      },
      {
        id: 2,
        name: 'Test #2',
        email: 'test2@email2.com',
        schedule: { all_day: false, opened: false },
        numbers: %w[3 4],
        active: true,
        count: 10
      },
      {
        id: 3,
        name: 'Test #3',
        email: 'test3@email3.com',
        schedule: { all_day: false, opened: false },
        numbers: %w[5 6],
        active: false,
        count: 99
      }
    ]
  end

  context 'Equal' do
    context 'when value is not Hash' do
      it 'returns only filters items' do
        filters = { active_eq: true }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { 'schedule.all_day_eq': true }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { 'numbers.0_eq': '1' }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { 'numbers.0._eq': '3' }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(1)
      end
    end

    context 'when value is Hash contains predicates' do
      it 'returns only filters items' do
        filters = { active: { eq: true } }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { 'schedule.all_day': { eq: true } }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = {
          'schedule.all_day': { eq: true },
          'schedule.opened': { eq: true }
        }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = {
          'schedule.opened': { eq: false },
          'schedule.all_day': { eq: false }
        }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = {
          'schedule.opened': { eq: true },
          name: { cont: 'Test', notcont: '#1' }
        }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(0)
      end
    end
  end

  context 'NotEqual' do
    it 'returns only filters items' do
      filters = { active_noteq: true }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end
  end

  context 'Contains' do
    it 'returns only filters items' do
      filters = { name_cont: '#3' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
      expect(collection.result.first[:name]).to eq('Test #3')
    end

    it 'returns only filters items' do
      filters = {
        name: {
          cont: 'Test',
          not_cont: ['#2', '#3']
        }
      }

      collection = Recollect::Filterable.call(data, filters)
      collect_ids = Recollect::Array.pluck(collection.result, 'id')

      expected_ids = [1]

      expect(collection.result.size).to eq(1)
      expect(collect_ids).to eq(expected_ids)
    end
  end

  context 'NotContains' do
    it 'returns only filters items' do
      filters = { name_notcont: '#3' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(2)
      expect(collection.result.first[:name]).to eq('Test #1')
    end
  end

  context 'LessThan' do
    it 'returns only filters items' do
      filters = { count_lt: 10 }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end
  end

  context 'LessThanEqual' do
    it 'returns only filters items' do
      filters = { count_lteq: 10 }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(2)
    end
  end

  context 'GreaterThan' do
    it 'returns only filters items' do
      filters = { count_gt: 10 }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end
  end

  context 'GreaterThanEqual' do
    it 'returns only filters items' do
      filters = { count_gteq: 10 }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(2)
    end
  end

  context 'Startify' do
    it 'returns only filters items' do
      filters = { email_start: 'test1' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end

    it 'returns only filters items' do
      filters = { email_start: 'test2' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end

    it 'returns only filters items' do
      filters = { email_start: 'test3' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end
  end

  context 'Endify' do
    it 'returns only filters items' do
      filters = { email_end: 'email1.com' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end

    it 'returns only filters items' do
      filters = { email_end: 'email2.com' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end

    it 'returns only filters items' do
      filters = { email_end: 'email3.com' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(1)
    end
  end

  context 'NotStartify' do
    it 'returns only filters items' do
      filters = { email_notstart: 'test1' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(2)
    end
  end

  context 'NotEndify' do
    it 'returns only filters items' do
      filters = { email_notend: 'email1.com' }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(2)
    end
  end

  context 'Included' do
    it 'returns only filters items' do
      filters = {
        'schedule.opened': { in: [false, true] }
      }

      collection = Recollect::Filterable.call(data, filters)

      expect(collection.result.size).to eq(3)
    end

    context 'when value is Array' do
      it 'returns only filters items' do
        filters = { numbers_in: ['1'] }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(1)
      end
    end

    context 'when value is String' do
      it 'returns only filters items' do
        filters = {
          numbers: {
            in: '1',
            not_in: %w[3 6]
          }
        }

        collection = Recollect::Filterable.call(data, filters)
        collect_ids = Recollect::Array.pluck(collection.result, 'id')

        expected_ids = [1]

        expect(collection.result.size).to eq(1)
        expect(collect_ids).to eq(expected_ids)
      end

      it 'returns only filters items' do
        filters = { numbers_in: '1' }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(1)
      end
    end

    context 'when value is Boolean' do
      it 'returns only filters items' do
        filters = { active_in: [true] }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { active_in: [true, false] }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(3)
      end
    end
  end

  context 'NotIncluded' do
    context 'when value is Array' do
      it 'returns only filters items' do
        filters = { numbers_notin: ['1'] }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { numbers_notin: %w[1 3] }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(1)
      end
    end

    context 'when value is String' do
      it 'returns only filters items' do
        filters = { numbers_notin: '1' }

        collection = Recollect::Filterable.call(data, filters)

        expect(collection.result.size).to eq(2)
      end
    end
  end
end
