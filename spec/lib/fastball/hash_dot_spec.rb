require 'spec_helper'

describe Fastball::HashDot do
  it 'maps methods to keys' do
    h = Fastball::HashDot.new foo: 'bar', 'biz' => 42

    expect(h).to respond_to(:foo)
    expect(h.foo).to eq('bar')

    expect(h).to respond_to(:biz)
    expect(h.biz).to eq(42)
  end

  it 'allows nested key lookups' do
    h = Fastball::HashDot.new nested: { 'hashes' => { are_fun: 'hooray!' } }
    expect(h.nested.hashes.are_fun).to eq('hooray!')
  end

  it 'records when key not found' do
    h = described_class.new
    expect(-> { h.whatever }).to change { h.missing_items.count }.by(1)
  end

  it 'raises when nested key not found' do
    h = described_class.new
    expect(-> { h.whatever.hello }).to raise_error(NoMethodError)
  end
end
