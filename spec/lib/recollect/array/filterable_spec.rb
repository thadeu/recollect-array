# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Recollect::Array::Filterable do
  let(:data) do
    [
      {
        id: 1,
        name: 'Test #1',
        email: 'test1@email1.com',
        schedule: { all_day: true, opened: true },
        numbers: %w[1 2],
        phones: [
          { number: '123', ddd: '10', position: { value: [1], status: { enum: %w[online] } } },
          { number: '456', ddd: '11', position: { value: [2], status: { enum: %w[offline] } } }
        ],
        active: true,
        count: 9
      },
      {
        id: 2,
        name: 'Test #2',
        email: 'test2@email2.com',
        schedule: { all_day: false, opened: false },
        numbers: %w[3 4],
        phones: [],
        active: true,
        count: 10
      },
      {
        id: 3,
        name: 'Test #3',
        email: 'test3@email3.com',
        schedule: { all_day: false, opened: false },
        numbers: %w[5 6],
        phones: [
          { number: '789', ddd: '13' },
        ],
        active: false,
        count: 99
      }
    ]
  end

  context 'Deep values' do
    context 'eq' do
      context 'array of hash' do
        it 'match array values in deep structure' do
          filters = { 'phones.number': { eq: '456' } }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(1)
        end

        it 'match array values in deep structure' do
          filters = {
            'phones.position.value': {
              eq: 1
            }
          }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(1)
          expect(collection.first[:id]).to eq(1)
        end

        it 'match array values in deep structure' do
          filters = {
            'phones.position.status.enum': {
              eq: 'online'
            }
          }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(1)
          expect(collection.first[:id]).to eq(1)
        end

        it 'match array values in deep structure' do
          filters = {
            'phones.0.position.status.enum': {
              eq: 'online'
            }
          }

          collection = described_class.call(data.slice(0,1), filters)

          expect(collection.size).to eq(1)
          expect(collection.first[:id]).to eq(1)
        end

        it 'match array values in deep structure' do
          filters = {
            'phones.1.position.status.enum': {
              eq: 'offline'
            }
          }

          collection = described_class.call(data.slice(0,1), filters)

          expect(collection.size).to eq(1)
          expect(collection.first[:id]).to eq(1)
        end

        it 'match array values in deep structure' do
          filters = {
            'phones.1.position.status': {
              eq: { enum: ['offline'] }
            }
          }

          collection = described_class.call(data.slice(0,1), filters)

          expect(collection.size).to eq(1)
          expect(collection.first[:id]).to eq(1)
        end
      end
    end

    context 'not_eq' do
      context 'array of hash' do
        it 'match array values in deep structure' do
          filters = { 'phones.number': { not_eq: '456' } }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(2)
        end
      end
    end

    context 'cont' do
      context 'array of hash' do
        it 'match array values in deep structure' do
          filters = { 'phones.number': { cont: '456' } }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(1)
        end
      end
    end

    context 'start' do
      context 'array of hash' do
        it 'match array values in deep structure' do
          filters = {
            'phones.number': { st: '4' },
            'phones.ddd': { st: '1' }
          }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(1)
        end
      end
    end

    context 'end' do
      context 'array of hash' do
        it 'match array values in deep structure' do
          filters = {
            'phones.number': { end: '9' }
          }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(1)
        end
      end
    end

    context 'in' do
      context 'array of hash' do
        it 'match array values in deep structure' do
          filters = { 'phones.number': { in: ['789', '456'] } }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(2)
        end
      end
    end
  end

  context 'Equal' do
    context 'when value is not Hash' do
      it 'returns only filters items' do
        filters = { active: true }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { active_eq: true }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { 'schedule.all_day_eq': true }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { 'numbers.0_eq': '1' }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { 'numbers.0._eq': '3' }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(1)
      end
    end

    context 'when value is Hash contains predicates' do
      context 'and hash value is Callable' do
        it 'returns only filters items' do
          filters = {
            active: {
              eq: -> { true }
            }
          }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(2)
        end

        it 'returns only filters items' do
          filters = {
            active: { eq: ActiveTruthy },
            numbers: { in: NumbersAvailable }
          }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(1)
        end

        it 'returns only filters items' do
          filters = {
            active: {
              eq: ActiveFalsey
            }
          }

          collection = described_class.call(data, filters)

          expect(collection.size).to eq(1)
        end
      end

      it 'returns only filters items' do
        filters = { active: { eq: true } }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { 'schedule.all_day': { eq: true } }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = {
          'schedule.all_day': { eq: true },
          'schedule.opened': { eq: true }
        }

        collection = described_class.call([data[0]], filters)

        expect(collection.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = {
          'schedule.opened': { eq: false },
          'schedule.all_day': { eq: false },
        }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = {
          'schedule.opened': { eq: true },
          name: { cont: 'Test', notcont: '#1' },
        }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(0)
      end
    end
  end

  context 'NotEqual' do
    it 'returns only filters items' do
      filters = { active_noteq: true }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
    end
  end

  context 'Contains' do
    it 'returns only filters items' do
      filters = { name_cont: '#3' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
      expect(collection.first[:name]).to eq('Test #3')
    end

    it 'returns only filters items' do
      filters = {
        name: {
          cont: 'Test',
          not_cont: ['#2', '#3']
        }
      }

      collection = described_class.call(data, filters)

      expected_ids = [1]

      expect(collection.size).to eq(1)
    end
  end

  context 'NotContains' do
    it 'returns only filters items' do
      filters = { name_notcont: '#3' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(2)
      expect(collection.first[:name]).to eq('Test #1')
    end
  end

  context 'LessThan' do
    it 'returns only filters items' do
      filters = { count_lt: 10 }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
    end
  end

  context 'LessThanEqual' do
    it 'returns only filters items' do
      filters = { count_lteq: 10 }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(2)
    end
  end

  context 'GreaterThan' do
    it 'returns only filters items' do
      filters = { count_gt: 10 }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
    end
  end

  context 'GreaterThanEqual' do
    it 'returns only filters items' do
      filters = { count_gteq: 10 }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(2)
    end
  end

  context 'Startify' do
    it 'returns only filters items' do
      filters = { email_start: 'test1' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
    end

    it 'returns only filters items' do
      filters = { email_start: 'test2' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
    end

    it 'returns only filters items' do
      filters = { email_start: 'test3' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
    end
  end

  context 'Endify' do
    it 'returns only filters items' do
      filters = { email_end: 'email1.com' }

      collection = described_class.call(data.dup, filters)

      expect(collection.size).to eq(1)
    end

    it 'returns only filters items' do
      filters = { email_end: 'email2.com' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
    end

    it 'returns only filters items' do
      filters = { email_end: 'email3.com' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(1)
    end
  end

  context 'NotStartify' do
    it 'returns only filters items' do
      filters = { email_notstart: 'test1' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(2)
    end
  end

  context 'NotEndify' do
    it 'returns only filters items' do
      filters = { email_notend: 'email1.com' }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(2)
    end
  end

  context 'Included' do
    it 'returns only filters items' do
      filters = {
        'schedule.opened': { in: [false, true] }
      }

      collection = described_class.call(data, filters)

      expect(collection.size).to eq(3)
    end

    context 'when value is Array' do
      it 'returns only filters items' do
        filters = { numbers_in: ['1'] }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(1)
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

        collection = described_class.call(data, filters)

        expected_ids = [1]

        expect(collection.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { numbers_in: '1' }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(1)
      end
    end

    context 'when value is Boolean' do
      it 'returns only filters items' do
        filters = { active_in: [true] }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { active_in: [true, false] }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(3)
      end
    end
  end

  context 'NotIncluded' do
    context 'when value is Array' do
      it 'returns only filters items' do
        filters = { numbers_notin: ['1'] }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(2)
      end

      it 'returns only filters items' do
        filters = { numbers_notin: %w[1 3] }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(1)
      end
    end

    context 'when value is String' do
      it 'returns only filters items' do
        filters = { numbers_notin: '1' }

        collection = described_class.call(data, filters)

        expect(collection.size).to eq(2)
      end
    end
  end
end
