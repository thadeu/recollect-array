# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Recollect::Array do
  let(:data) do
    [
      {
        id: 1,
        name: 'Test #1',
        email: 'test1@email1.com',
        schedule: { all_day: true },
        numbers: %w[1 2],
        phones: [
          { number: '123', ddd: '11' },
          { number: '456', ddd: '11' }
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
        schedule: { all_day: false, opened: true },
        numbers: %w[5 6],
        phones: [],
        active: false,
        count: 99
      }
    ]
  end

  context '.filter' do
    context 'Equal' do
      it 'returns only filters items' do
        filters = { active: { eq: true } }

        collection = described_class.filter(data, filters)

        expect(collection.size).to eq(2)
      end

      it 'returns only filters items' do
        data.push({ active: false, count: 99, schedule: { all_day: true, opened: true } })

        collection = described_class.filter(data, active: false, count: 99, 'schedule.all_day': true, 'schedule.opened': true)

        expect(collection.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { 'schedule.all_day_eq': true }

        collection = described_class.filter(data, filters)

        expect(collection.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { 'numbers.0_eq': '1' }

        collection = described_class.filter(data, filters)

        expect(collection.size).to eq(1)
      end
    end
  end
end
