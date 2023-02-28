# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Recollect::Array::Utility::TryFetchOrBlank do
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
    subject(:result) { described_class.call(hash, iteratee) }

    context 'iteratee one level' do
      let(:hash) { { a: 1, b: { c: 2 }, d: ['1'] } }
      let(:iteratee) { 'd.0' }

      it { expect(result).to eq('1') }
    end

    context 'iteratee one level' do
      let(:hash) { { a: 1, b: { c: 2 }, d: [{ e: 3 }] } }
      let(:iteratee) { 'd.0.e' }

      it { expect(result).to eq(3) }
    end

    context 'iteratee nested levels on the complex hash' do
      let(:hash) do
        {
          a: 1,
          b: { c: 2 },
          d: [
            {
              e: [
                { e1: 1 },
                { e2: 2 },
                { e3: 3 }
              ]
            }
          ]
        }
      end

      it { expect(described_class[hash, 'd.0.e.2.e3']).to eq(3) }
      it { expect(described_class[hash, 'd.0.e.[2].e3']).to eq(3) }
      it { expect(described_class[hash, 'd.0.e[2].e3']).to eq(3) }
      it { expect(described_class[hash, 'd[0]e.2.e3']).to eq(3) }
      it { expect(described_class[hash, 'd.[0].e[1]e2']).to eq(2) }
      it { expect(described_class[hash, 'd[0]e[1]e2']).to eq(2) }
    end
  end
end
