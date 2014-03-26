require 'spec_helper'

describe Transaction do
  it {should have_many :returns}
  it {should have_many :quantities}
  it {should belong_to :cashier}
end
