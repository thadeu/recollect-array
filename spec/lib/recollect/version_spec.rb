# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Recollect do
  it 'must have a version number' do
    expect(described_class::VERSION).to eq('0.0.4')
  end
end
