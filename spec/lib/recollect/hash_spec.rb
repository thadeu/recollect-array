# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Recollect::Array::Hashie do
  let(:hash) do
    {
      user: {
        id: 1,
        name: 'Test #1',
        email: 'test1@email1.com',
        schedule: { all_day: true },
        numbers: %w[1 2],
        active: true,
        count: 9
      }
    }
  end

  context '.get' do
    context 'when nested Array' do
      it 'retrive value' do
        result = described_class.get(hash, 'user.numbers.1')

        expect(result).to eq('2')
      end
    end

    context 'when nested Hash' do
      it 'retrive value' do
        result = described_class.get(hash, 'user.schedule.all_day')

        expect(result).to eq(true)
      end
    end

    context 'when root path' do
      it 'retrive value' do
        result = described_class.get(hash, 'user.id')

        expect(result).to eq(1)
      end
    end

    context 'when full object' do
      it 'retrive value' do
        result = described_class.get(hash, 'user')

        expect(result).to eq(hash[:user])
      end
    end
  end
end
