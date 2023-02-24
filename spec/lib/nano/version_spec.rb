# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nano do
  it 'must have a version number' do
    expect(described_class::VERSION).to eq('0.0.1')
  end
end
