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
        schedule: { all_day: false, opened: true },
        numbers: %w[5 6],
        active: false,
        count: 99
      }
    ]
  end

  context '.filter' do
    context 'Equal' do
      it 'returns only filters items' do
        filters = { active_eq: true }

        collection = described_class.filter(data, filters)

        expect(collection.result.size).to eq(2)
      end
      
      it 'returns only filters items' do
        data.push({ active: false, count: 99, schedule: { all_day: true, opened: true } })

        collection = described_class.filter(data, active: false, count: 99, 'schedule.all_day': true, 'schedule.opened': true)

        expect(collection.result.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { 'schedule.all_day_eq': true }

        collection = described_class.filter(data, filters)

        expect(collection.result.size).to eq(1)
      end

      it 'returns only filters items' do
        filters = { 'numbers.0_eq': '1' }

        collection = described_class.filter(data, filters)

        expect(collection.result.size).to eq(1)
      end
    end
  end

  context '.pluck' do
    context 'when root path' do
      it 'retrive value' do
        result = described_class.pluck(data, 'id')

        expect(result).to eq([1, 2, 3])
      end

      it 'retrive value' do
        result = described_class.pluck([], 'id')

        expect(result).to eq([])
      end
    end

    context 'when nested Hash path' do
      it 'retrive value' do
        result = described_class.pluck(data, 'schedule.all_day')

        expect(result).to eq([true, false, false])
      end
    end

    context 'when nested Array path' do
      it 'retrive value' do
        result = described_class.pluck(data, 'numbers.0')

        expect(result).to eq(%w[1 3 5])
      end
    end
  end
end
