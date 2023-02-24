# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Recollect::Utility::TryFetchOrBlank do
  context 'Hash' do
    it 'check one level' do
      hash = {
        a: 1,
        b: { c: 2 },
        d: ['1']
      }

      expect(described_class.call(hash, :a)).to eq(1)
    end

    it 'check two levels' do
      hash = { a: 1, b: { c: 2 }, d: ['1'] }

      expect(described_class.call(hash, :b, :c)).to eq(2)
    end

    it 'check two levels' do
      hash = {
        a: 1,
        b: {}
      }

      expect(described_class.call(hash, :b, :c)).to be_nil
    end
  end

  context 'Array' do
    it 'check array levels' do
      hash = { a: 1, b: { c: 2 }, d: ['1'] }
      expect(described_class.call(hash, 'd.0')).to eq('1')
    end

    it 'check array + hash levels' do
      hash = { a: 1, b: { c: 2 }, d: [{ e: 3 }] }

      expect(described_class[hash, 'd.0.e']).to eq(3)
    end
  end
end
